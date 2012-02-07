require 'rails/generators/base'
require 'rails/generators/migration'
require 'rails/generators/active_model'
require 'rails/generators/active_record/migration'
require 'active_record'

module Model
  module Generators
    class AssetGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      # ACTITIVE RECORD
      # Set the current directory as base for the inherited generators.
      def self.base_root
        File.dirname(__FILE__)
      end

      def create_model_file
        copy_file "model.rb", "app/models/asset.rb"
      end

      def create_migration_file
        migration_template "migration.rb", "db/migrate/create_assets.rb"
      end

      protected
        def parent_class_name
          options[:parent] || "ActiveRecord::Base"
        end
    end
  end
end

