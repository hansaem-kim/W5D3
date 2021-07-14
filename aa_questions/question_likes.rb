require_relative 'questions_database'

class QuestionLikes

    attr_accessor :users_id, :questions_id, :id 

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