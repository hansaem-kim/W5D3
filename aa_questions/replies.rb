require_relative 'questions_database'

class Replies

    attr_accessor :id, :body, :subect_questions_id, :users_id, :parent_reply_id 

    def self.find_by_id(id)
        replies = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL

       Replies.new(replies.first)
    end

    def self.find_by_user_id(users_id)
     replies = QuestionsDatabaseConnection.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL

        replies.map {|reply| Replies.new(reply)}
    end 

    def self.find_by_questions_id(questionss_id)
     replies = QuestionsDatabaseConnection.instance.execute(<<-SQL, questions_id)
            SELECT
                *
            FROM
                replies
            WHERE
                questions_id = ?
        SQL

        replies.map {|reply| Replies.new(reply)}
    end 

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @subect_questions_id = options['subect_questions_id']
        @users_id = options['users_id']
        @parent_reply_id = options['parent_reply_id']
    end
end