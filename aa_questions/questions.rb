require_relative 'questions_database'
require_relative 'users'
require_relative 'replies'
require_relative 'question_follows'

class Questions

    attr_accessor :title, :body, :author_id, :id

    def self.most_followed(n)
        QuestionFollows.most_followed_questions(n)
    end

    def self.find_by_id(id)
        questions = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL

        Questions.new(questions.first)
    end

    def self.find_by_author_id(author_id)
         questions = QuestionsDatabaseConnection.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                author_id = ?
        SQL

        questions.map {|question| Questions.new(question)}
    end 

    def initialize(options)
        @title = options['title']
        @body = options['body']
        @id = options['id']
        @author_id = options['author_id']
    end

    def author
        Users.find_by_id(@author_id)
    end

    def replies
        Replies.find_by_questions_id(@id)
    end

    def followers
        QuestionFollows.followers_for_question_id(@id)
    end 

    def likers
        QuestionLikes.likers_for_question_id(@id)
    end

    def num_likes
        QuestionLikes.num_likes_for_question_id(@id)
    end

    def most_liked(n)
        QuestionLikes.most_liked_questions(n)
    end 

    

end
