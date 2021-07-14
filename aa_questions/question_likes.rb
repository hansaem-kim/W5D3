require_relative 'questions_database'
require_relative 'questions'

class QuestionLikes

    attr_accessor :users_id, :questions_id, :id 

    def self.likers_for_question_id(questions_id)
        users = QuestionsDatabaseConnection.instance.execute(<<-SQL, questions_id)
            SELECT
                *
            FROM
                question_likes
            JOIN
                users ON users.id = question_likes.users_id
            WHERE
                questions_id = ?
        SQL

        users.map {|user| Users.new(user)}
        
    end

    def self.num_likes_for_question_id(questions_id)
        likes = QuestionsDatabaseConnection.instance.execute(<<-SQL, questions_id)
            SELECT
                COUNT(*) AS total_likes
            FROM
                question_likes
            WHERE
                questions_id = ?
            GROUP BY
                questions_id
        SQL

        likes.first["total_likes"]
    end

    def self.liked_questions_for_user_id(users_id)
        questions = QuestionsDatabaseConnection.instance.execute(<<-SQL, users_id)
            SELECT
                *
            FROM
                question_likes
            JOIN
                questions ON questions.id = question_likes.questions_id
            WHERE
                users_id = ?
        SQL

        questions.map {|question| Questions.new(question)}
    end

    def self.find_by_id(id)
        question_likes = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                id = ?
        SQL

        QuestionLikes.new(question_likes.first)
    end

    def initialize(options)
        @id = options['id']
        @users_id = options['users_id']
        @questions_id = options['questions_id']
    end
end