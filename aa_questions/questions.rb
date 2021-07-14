require_relative 'questions_database'

class Questions

    attr_accessor :title, :body, :author_id, :id

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
end