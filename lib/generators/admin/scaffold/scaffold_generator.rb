require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'
require 'rails/generators/active_record/migration'
require 'active_record'
require 'haml'

module Admin
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      check_class_collision

      class_option :orm, :banner => "NAME", :type => :string, :required => true,
                          :desc => "ORM to generate the controller for"

      # ACTITIVE RECORD
      # Set the current directory as base for the inherited generators.
      def self.base_root
        File.dirname(__FILE__)
      end

      # MODEL
      def create_migration_file
        migration_template "migration.rb", "db/migrate/create_#{table_name}.rb"
      end

      def create_model_files
        template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
        attributes.each do |attribute|
          if attribute.type.to_s.include? '_file'
            @file_class_name = class_name + attribute.name.to_s.classify
            template 'model_file.rb', "app/models/#{file_name}_#{attribute.name.singularize}.rb"
          end
        end
      end

      # CONTROLLER
      def create_controller_files
        template 'controller.rb', File.join('app/controllers/admin', class_path, "#{controller_file_name}_controller.rb")
        attributes.each do |attribute|
          if attribute.type.to_s.include? '_file'
            @controller_file_class_name = controller_class_name + attribute.name.to_s.pluralize.camelize
            @file_class_name = class_name + attribute.name.to_s.classify
            template 'files_controller.rb', "app/controllers/admin/#{file_name}_#{attribute.name.pluralize}_controller.rb"
          end
        end
      end

      # VIEW
      def create_root_folder
        empty_directory File.join("app/views/admin", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          template 'views/' + filename, File.join("app/views/admin", controller_file_path, filename)
        end
      end

      protected

        def parent_class_name
          options[:parent] || "ActiveRecord::Base"
        end

        def available_views
          %w(index edit new _form)
        end

        def format
          :html
        end

        def handler
          :haml
        end

        def filename_with_extensions(name)
          [name, format, handler].compact.join(".")
        end
    end

  end
end

