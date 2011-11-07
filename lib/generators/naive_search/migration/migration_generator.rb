require 'rails/generators'
require 'rails/generators/migration'

module NaiveSearch
  module Generators
    
    class MigrationGenerator < Rails::Generators::NamedBase
      desc "Generates migration file for the given model name"
      
      include Rails::Generators::Migration
      
      source_root File.expand_path('../../../templates', __FILE__)

      def self.next_migration_number(dirname)
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def create_migration
        migration_template "add_naive_search_index.rb", "db/migrate/add_naive_search_index_to_#{class_name.underscore}.rb"
      end
    end
    
  end
end
