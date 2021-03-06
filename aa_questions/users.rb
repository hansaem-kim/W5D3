require_relative 'questions_database'
require_relative 'questions'
require_relative 'replies'
require_relative 'question_follows'

class Users

    attr_accessor :fname, :lname, :id

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
    
    def followed_questions
        QuestionFollows.followed_questions_for_user_id(@id)
    end 

    def liked_questions
        QuestionLikes.liked_questions_for_user_id(@id)
    end

    def average_karma 
         karma = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
            SELECT
                COUNT(DISTINCT(question_likes.questions_id)) / 
                CAST(COUNT(DISTINCT(questions.id)) AS FLOAT) AS average  
            FROM
                questions
            LEFT OUTER JOIN 
                question_likes ON question_likes.questions_id = questions.id

            WHERE
                questions.author_id = ? 
        SQL

        karma.first["average"]
    end 

    def save 
        if @id == nil 
            QuestionsDatabaseConnection.instance.execute(<<-SQL, @fname, @lname)
                INSERT INTO
                    users(fname, lname)
                VALUES
                    (?, ?)
            SQL
            self.id = QuestionsDatabaseConnection.instance.last_insert_row_id
        else  
            QuestionsDatabaseConnection.instance.execute(<<-SQL, @fname, @lname, @id)
                UPDATE
                    users
                SET
                    fname = ?, lname = ? 
                WHERE
                    users.id = ?
            SQL
        end 
    end 
end

a = Users.new("fname" => "three", "lname" => "four")
a.save