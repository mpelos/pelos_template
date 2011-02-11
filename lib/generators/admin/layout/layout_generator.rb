module Admin
  module Generators
    class LayoutGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_admin_layout
        copy_file "app/controllers/admin/admin_controller.rb", "app/controllers/admin/admin_controller.rb"
        copy_file "app/stylesheets/admin.sass", "app/stylesheets/admin.sass"
        copy_file "app/views/layouts/admin.html.haml", "app/views/layouts/admin.html.haml"
        copy_file "config/credentials.yml", "config/credentials.yml"
        copy_file "public/javascripts/admin.js", "public/javascripts/admin.js"
        copy_file "public/images/admin/cross.png", "public/images/admin/cross.png"
        copy_file "public/images/admin/delete.png", "public/images/admin/delete.png"
        copy_file "public/images/admin/document--pencil.png", "public/images/admin/document--pencil.png"
        copy_file "public/images/admin/logo.png", "public/images/admin/logo.png"
        copy_file "public/images/admin/magnifier.png", "public/images/admin/magnifier.png"
        copy_file "public/images/admin/slash.png", "public/images/admin/slash.png"
        copy_file "public/images/admin/tick.png", "public/images/admin/tick.png"
      end

      def add_namespace_route
        route_config = "namespace :admin do"
        route_config << " end"
        route route_config
      end
    end
  end
end

