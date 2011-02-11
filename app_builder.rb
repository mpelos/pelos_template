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
    empty_directory 'app'

    inside "app" do
      directory "controllers"
      directory "helpers"
      directory "mailers"
      empty_directory "models"
      directory "stylesheets"
      empty_directory "views"
      inside "views" do
        empty_directory "application_mailer"
        empty_directory "layouts"
        inside "layouts" do
          template "application.html.haml"
        end
      end
    end
  end

  def config
    empty_directory "config"

    inside "config" do
      template "application.rb"
      template "deploy.rb"
      template "environment.rb"
      template "routes.rb"
      copy_file "compass.rb"

      directory "environments"
      directory "initializers"
      directory "locales"
    end
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
    empty_directory "lib"
    empty_directory_with_gitkeep "lib/tasks"
    directory "lib/generators"
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
end

