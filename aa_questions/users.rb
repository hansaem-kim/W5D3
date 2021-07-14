require_relative 'questions_database'

class User

    attr_accessor :fname, :lanme, :id

    def self.find_by_id(id)
        users = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL

        User.new(users.first)
    end

    def initialize(options)
        @fname = options['fname']
        @lname = options['lname']
        @id = options['id']
    end
end
