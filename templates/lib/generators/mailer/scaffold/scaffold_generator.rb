module Mailer
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      check_class_collision

      def create_files
        template "controller.rb", File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
        template "index.html.haml", "app/views/#{controller_file_path}/index.html.haml"
        copy_file "create.js.erb", "app/views/#{controller_file_path}/create.js.erb"
        template "mailer_view.text.erb", "app/views/application_mailer/send_#{singular_table_name}_mail.text.erb"
      end

      def insert_mailer_method_into_application_mailer
        mailer_method = "\n\n  def send_#{singular_table_name}_mail(#{singular_table_name})\n  "
        mailer_method << "  @#{singular_table_name} = #{singular_table_name}\n  "
        mailer_method << "  mail(:to => 'to@example.com', :subject => 'Mensagem de ' + #{singular_table_name}['#{attributes.first.name}'])\n  "
        mailer_method << "end"

        inject_into_file 'app/mailers/application_mailer.rb', mailer_method, :after => "# Mailer methods"
      end
    end
  end
end

