class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # http://stackoverflow.com/questions/16297797/add-custom-field-column-to-devise-with-rails-4
  before_filter :configure_permitted_parameters, if: :devise_controller?
  def load_key!
    redirect_to(key_path) unless session[:master_key]
  end
  protected

  def configure_permitted_parameters
    registration_params = [:first_name, :last_name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) {
          |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) {
          |u| u.permit(registration_params)
      }
    end
  end

  def parse_datetime_form datetime
    begin
      # Find this DATE_FORMAT definition in initializers/date_format.rb
      Time.strptime(datetime, Time::DATE_FORMATS[:datetimepicker])
    rescue
      puts "couldn't parse the given datetime string: #{datetime}"
      nil
    end
  end
end
