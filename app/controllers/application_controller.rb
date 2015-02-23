class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login
  helper_method :current_user

  def require_login
    go_get_login unless session[:uid]
  end

  def current_user
    @current_user ||= User.find_by_uuid(session[:uid]) if session[:uid]
  end

  def go_get_login
    url = url_for({:protocol=>request.protocol, :host=>request.host, :port=>request.port}.merge(params))
    flash[:warning]='Please login to continue'
    #session[:return_to]= request.path

    respond_to do |wants|
      wants.html { redirect_to '/signin' }
      wants.js { render :update do |page|
        page.redirect_to '/signin'
      end }
    end
  end


end
