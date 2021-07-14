require_relative 'questions_database'

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

    def initialize(options)
        @id = options['id']
        @users_id = options['users_id']
        @questions_id = options['questions_id']
    end
end
