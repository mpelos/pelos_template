module Admin
  module Generators
    class LayoutGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_admin_layout
        copy_file "app/controllers/admin/admin_controller.rb"
        copy_file "app/stylesheets/admin.sass"
        copy_file "app/views/layouts/admin.html.haml"
        create_file "app/views/layouts/admin/_menu.html.haml"
        copy_file "app/views/layouts/admin/show.html.haml"
        directory "public"
      end

      def add_namespace_route
        route_config = "\n  namespace :admin do\n  "
        route_config << "  # Admin Scaffold's references for routes. Do not erase.\n  "
        route_config << "end\n  "

        inject_into_file 'config/routes.rb', route_config, :before => "# The priority is based upon order of creation:"
      end

      def run_friendly_id_generator
        system "rails g friendly_id"
      end

      def help_message
        puts "\nDon't forget to run 'rake db:migrate'\n"
      end
    end
  end
end

