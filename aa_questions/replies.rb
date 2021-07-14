require_relative 'questions_database'
require_relative 'users'
require_relative 'questions'

class Replies

    attr_accessor :id, :body, :subject_questions_id, :users_id, :parent_reply_id 

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
     replies = QuestionsDatabaseConnection.instance.execute(<<-SQL, users_id)
            SELECT
                *
            FROM
                replies
            WHERE
                users_id = ?
        SQL

        replies.map {|reply| Replies.new(reply)}
    end 

    def self.find_by_questions_id(subject_questions_id)
     replies = QuestionsDatabaseConnection.instance.execute(<<-SQL, subject_questions_id)
            SELECT
                *
            FROM
                replies
            WHERE
                subject_questions_id = ?
        SQL

        replies.map {|reply| Replies.new(reply)}
    end 

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @subject_questions_id = options['subject_questions_id']
        @users_id = options['users_id']
        @parent_reply_id = options['parent_reply_id']
    end

    def author
        Users.find_by_id(@users_id)
    end

    def question
        Questions.find_by_id(@subject_questions_id)
    end

    def parent_reply
        Replies.find_by_id(@parent_reply_id)
    end

    def child_replies
        replies = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL

        replies.map {|reply| Replies.new(reply)}
    end

end