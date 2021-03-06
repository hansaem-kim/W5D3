require 'sqlite3'
require 'singleton'

class QuestionsDatabaseConnection < SQLite3::Database 
    include Singleton
    
    def initialize
        super('questions_data.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

