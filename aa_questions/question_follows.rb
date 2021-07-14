require_relative 'questions_database'
require_relative 'users'
require_relative 'questions'

class QuestionFollows

    attr_accessor :users_id, :questions_id, :id 

    def self.find_by_id(id)
        question_follows = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?
        SQL

        QuestionFollows.new(question_follows.first)
    end

    def self.followers_for_question_id(questions_id)
        users = QuestionsDatabaseConnection.instance.execute(<<-SQL, questions_id)
            SELECT
                *
            FROM
                question_follows
            JOIN 
                users ON question_follows.users_id = users.id
            JOIN 
                questions ON question_follows.questions_id = questions.id
            WHERE
                questions_id = ?
        SQL

        users.map {|user| Users.new(user)}
    end 

    def self.followed_questions_for_user_id(users_id)
    questions = QuestionsDatabaseConnection.instance.execute(<<-SQL, users_id)
        SELECT
            *
        FROM
            questions
        JOIN 
            users ON questions.author_id = users.id
        WHERE
            author_id = ?
    SQL

    questions.map {|question| Questions.new(question)}
end 

    def self.most_followed_questions(n=1)
        questions = QuestionsDatabaseConnection.instance.execute(<<-SQL, n)
            SELECT
                *
            FROM
                questions
            JOIN 
                question_follows ON questions.id = question_follows.questions_id
            GROUP BY 
                question_follows.questions_id
            ORDER BY 
                COUNT(*) DESC LIMIT ?
        SQL

        questions.map {|question| Questions.new(question)}

    end 

    def initialize(options)
        @id = options['id']
        @users_id = options['users_id']
        @questions_id = options['questions_id']
    end
end
