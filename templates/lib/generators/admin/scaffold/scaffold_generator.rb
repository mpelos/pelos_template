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
      class_option :ordination,     :aliases => "-O", :type => :boolean, :default => false, :desc => "Include an changeable ordination for items."
      class_option :friendly_id,    :aliases => "-F", :type => :boolean, :default => false, :desc => "Include friendly_id using the first attribute as reference."
      class_option :show,           :aliases => "-S", :type => :boolean, :default => false, :desc => "Include view show."
      class_option :image_subtitle, :aliases => "-I", :type => :boolean, :default => false, :desc => "Include subtitles in has_many_images."

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
          if attribute.type.to_s.include? '_file' or attribute.type.to_s.include? '_image'
            @file_class_name = class_name + attribute.name.to_s.classify
            @attribute_type = attribute.type
            template 'model_file.rb', "app/models/#{file_name}_#{attribute.name.singularize}.rb"
          end
        end
      end

      # CONTROLLER
      def create_controller_files
        template 'controller.rb', File.join('app/controllers/admin', class_path, "#{controller_file_name}_controller.rb")
        attributes.each do |attribute|
          if attribute.type.to_s.include? '_file' or attribute.type.to_s.include? '_image'
            controller_file_name = file_name + "_" + attribute.name.to_s.pluralize + "_controller"
            @controller_file_class_name = controller_file_name.camelize
            @file_class_name = class_name + attribute.name.to_s.classify
            template 'files_controller.rb', "app/controllers/admin/#{controller_file_name}.rb"
          end
        end
      end

      # VIEW
      def create_root_folder
        empty_directory File.join("app/views/admin", controller_file_path)
      end

      def copy_view_files
        @form = {}
        @form[:type] = attributes.map{|a| a.type.to_s.include? 'has_many'}.any? ? "nested_form_for" : "form_for"
        @form[:multipart] = ", :html => { :multipart => true }" if attributes.map{|a| a.type.to_s.include? '_file' or a.type.to_s.include? '_image'}.any?

        available_views.each do |view|
          filename = filename_with_extensions(view)
          template 'views/' + filename, File.join("app/views/admin", controller_file_path, filename)
        end

        if options.show?
          copy_file 'views/show.html.haml', "app/views/admin/#{controller_file_path}/show.html.haml"
        end
      end

      # ROUTE
      def add_route
        route_config = "resources :" + plural_table_name + " do\n    "
        route_config << "  post 'reorder', :on => :member\n    " if options.ordination?
        attributes.each do |attribute|
          if attribute.type.to_s.include? '_file' or attribute.type.to_s.include? '_image'
            route_config << "  resources :" + file_name + "_" + attribute.name.pluralize + ", :as => :" + attribute.name + ", :path => '" + attribute.name + "', :only => :destroy\n    "
          end
        end
        route_config << "end\n    "

        inject_into_file 'config/routes.rb', route_config, :before => "# Admin Scaffold's references for routes. Do not erase."
      end

      # MENU
      def add_item_to_menu
        append_file 'app/views/layouts/admin/_menu.html.haml' do
          "%li= link_to t('activerecord.attributes." + file_name + ".plural'), admin_" + plural_table_name + "_path, :id => '" + plural_table_name + "'\n\n"
        end
      end

      # LOCALE
      def add_translations_to_locale
        model_locale = "#{file_name}: '#{file_name.titleize}'\n      "
        attributes.each do |attribute|
          if attribute.type.to_s.include? '_file' or attribute.type.to_s.include? '_image'
            model_locale << "#{file_name}_#{attribute.name.singularize}: '#{attribute.name.singularize.titleize}'\n      "
          end
        end

        attributes_locale = "#{file_name}:\n      "
        attributes_locale << "  plural: '#{file_name.pluralize.titleize}'\n      "
        attributes_locale << "  gender: 'o'\n      "
        attributes.each do |attribute|
          if !attribute.type.to_s.include? '_file' and !attribute.type.to_s.include? '_image'
            attributes_locale << "  #{attribute.name}: '#{attribute.name.titleize}'\n      "
          end
        end

        inject_into_file 'config/locales/pt-BR.yml', model_locale, :before => "# Admin Scaffold's references for models. Do not erase."
        inject_into_file 'config/locales/pt-BR.yml', attributes_locale, :before => "# Admin Scaffold's references for attributes. Do not erase."
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

