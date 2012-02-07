class Admin::AdminController < ActionController::Base
  helper :all
  protect_from_forgery

  layout "admin"
  before_filter :authenticate

  protected
    def authenticate
      admin = YAML.load_file("#{Rails.root}/config/credentials.yml")['admin']

      authenticate_or_request_with_http_basic do |username, password|
        username == admin['user'] && password == admin['password']
      end
    end
end

