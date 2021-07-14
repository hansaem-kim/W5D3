require_relative 'questions_database'
require_relative 'questions'
require_relative 'replies'

class Users

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

        Users.new(users.first)
    end

    def self.find_by_name(fname, lname)
     users = QuestionsDatabaseConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL

        users.map {|user| Users.new(user)}
    end 

    def initialize(options)
        @fname = options['fname']
        @lname = options['lname']
        @id = options['id']
    end

    def authored_questions
        Questions.find_by_author_id(@id)
    end

    def authored_replies
        Replies.find_by_user_id(@id)
    end
    

end
