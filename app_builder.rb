require 'net/http'
require 'thor/actions/empty_directory'

class Odin
  module Actions
    def directory(source, *args, &block)
      config = args.last.is_a?(Hash) ? args.pop : {}
      destination = args.first || source
      action Directory.new(self, source, destination || source, config, &block)
    end

    class Directory < Thor::Actions::EmptyDirectory #:nodoc:
      attr_reader :source

      def initialize(base, source, destination=nil, config={}, &block)
        @source = path + source.to_s
        @block  = block
        super(base, destination, { :recursive => true }.merge(config))
      end

      def invoke!
        base.empty_directory given_destination, config
        execute!
      end

      def revoke!
        execute!
      end

      protected
        def path
          "/home/marcelo/desenvolvimento/pelos_template/"
        end

        def execute!
          lookup = config[:recursive] ? File.join(source, '**') : source
          lookup = File.join(lookup, '{*,.[a-z]*}')

          Dir[lookup].sort.each do |file_source|
            next if File.directory?(file_source)
            file_destination = File.join(given_destination, file_source.gsub(source, '.'))
            file_destination.gsub!('/./', '/')

            case file_source
              when /\.empty_directory$/
                dirname = File.dirname(file_destination).gsub(/\/\.$/, '')
                next if dirname == given_destination
                base.empty_directory(dirname, config)
              when /\.tt$/
                destination = base.template(file_source, file_destination[0..-4], config, &@block)
              else
                destination = base.copy_file(file_source, file_destination, config, &@block)
            end
          end
        end

    end
  end
end

class AppBuilder
  def rakefile
    template "Rakefile"
  end

  def readme
    copy_file "README"
    copy_file "gitignore", ".gitignore"
    template "rvmrc", ".rvmrc"
    copy_file "Capfile"
  end

  def gemfile
    template "Gemfile"
  end

  def configru
    template "config.ru"
  end

  def app
    copy_file "app/controllers/application_controller.rb"
    copy_file "app/helpers/application_helper.rb"
    copy_file "app/helpers/form_helper.rb"
    copy_file "app/mailers/application_mailer.rb"
    empty_directory "app/models"
    copy_file "app/stylesheets/application.sass"
    copy_file "app/stylesheets/_base.sass"
    copy_file "app/stylesheets/_variables.sass"
    copy_file "app/views/layouts/application.html.haml"
  end

  def config
    template "config/application.rb"
    template "config/deploy.rb"
    template "config/environment.rb"
    template "config/routes.rb"
    copy_file "config/compass.rb"
    directory "config/environments"
    directory "config/initializers"
    directory "config/locales"
  end

  def database_yml
    template "config/databases/#{options[:database]}.yml", "config/database.yml"
    template "config/databases/#{options[:database]}.yml", "config/database_sample.yml"
  end

  def db
    directory "db"
  end

  def doc
    directory "doc"
  end

  def lib
    directory "lib"
  end

  def log
    empty_directory "log"

    inside "log" do
      %w( server production development test ).each do |file|
        create_file "#{file}.log"
        chmod "#{file}.log", 0666, :verbose => false
      end
    end
  end

  def public_directory
    directory "public", "public", :recursive => false
  end

  def images
    directory "public/images"
  end

  def stylesheets
    empty_directory_with_gitkeep "public/stylesheets"
  end

  def javascripts
    directory "public/javascripts"
  end

  def script
    directory "script" do |content|
      "#{shebang}\n" + content
    end
    chmod "script", 0755, :verbose => false
  end

  def test
    directory "test"
  end

  def tmp
    empty_directory "tmp"

    inside "tmp" do
      %w(sessions sockets cache pids).each do |dir|
        empty_directory(dir)
      end
    end
  end

  def vendor_plugins
    empty_directory_with_gitkeep "vendor/plugins"
  end

  protected
    def path
      "/home/marcelo/desenvolvimento/pelos_template/"
      #"https://github.com/mpelos/pelos_template/raw/master/"
    end

    def copy_file(source, destination=nil, config={})
      destination ||= source
      source = path + source.to_s

      create_file destination, nil, config do
        File.read(source)
        #Net::HTTP.get URI.parse(source)
      end
    end

    def template(source, destination=nil, config={})
      destination ||= source
      source = path + source.to_s
      context = instance_eval('binding')

      create_file destination, nil, config do
        ERB.new(::File.read(source), nil, '-').result(context)
      end
    end

    def directory(source, destination=nil, config={})
      action Odin::Actions::Directory.new(self, source, destination || source, config)
    end

    def rails_gemfile_entry
      if options.dev?
        <<-GEMFILE
gem 'rails', :path => '#{Rails::Generators::RAILS_DEV_PATH}'
gem 'arel',  :git => 'git://github.com/rails/arel.git'
gem "rack", :git => "git://github.com/rack/rack.git"
        GEMFILE
      elsif options.edge?
        <<-GEMFILE
gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'arel',  :git => 'git://github.com/rails/arel.git'
gem "rack", :git => "git://github.com/rack/rack.git"
        GEMFILE
      else
        <<-GEMFILE
gem 'rails', '#{Rails::VERSION::STRING}'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
# gem 'arel',  :git => 'git://github.com/rails/arel.git'
# gem "rack", :git => "git://github.com/rack/rack.git"
        GEMFILE
      end
    end

    def database_gemfile_entry
      options[:skip_active_record] ? "" : "gem '#{gem_for_database}'"
    end

end

