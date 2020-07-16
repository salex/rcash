class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  # makes sign_out abailable

  before_action :current_book
  before_action :current_user
  before_action :session_expiry
  # before_action :config_set
  

  def current_user
    @current_user ||= User.find_by(id:session[:user_id]) if session[:user_id]
    Current.user = @current_user
    @current_user
  end
  helper_method :current_user

  def require_login
    if current_user.nil? 
      redirect_to root_url, alert: "I'm sorry. I can't do that."
    end
  end
  helper_method :require_login

  def require_trustee
    if current_user.blank? || !current_user.is_trustee?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_trustee

  def require_admin
    if current_user.blank? || !current_user.is_admin?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_admin

  def current_book
    @current_book ||= Book.find_by(id:session[:book_id]) if session[:book_id]
    Current.book =@current_book 
    if @current_book.present? && session[:tree_ids].blank?
      @current_book.get_settings
    end
    @current_book
  end
  helper_method :current_book

  def tree_ids
    # tree_id control account options
    if session[:recent].blank?
      session[:recent] = {}
    end
    # the session[:tree_ids] is destroyed with any account change that resets settings
    @tree_ids = session[:tree_ids] = current_book.settings[:tree_ids]
  end
  helper_method :tree_ids

  def cant_do_that
    redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
  end
  helper_method :cant_do_that

  def session_expiry
    if current_user.present? && session[:expires_at].present?
      get_session_time_left
      unless @session_time_left > 0
        if @current_user.present?
          # sign_out and redirect for new login
          sign_out
          deny_access 'Your session has timed out. Please log back in.'
        else
          # just kill session and start a new one
          sign_out
        end
      end
    else
      # expire all sessions, even if not user to midnight
      session[:expires_at] = Time.now + 30.minutes
    end

  end
  
  def get_session_time_left
    expire_time = Time.parse(session[:expires_at]) || Time.now
    @session_time_left = (expire_time - Time.now).to_i
    @expires_at = expire_time.strftime("%I:%M:%S%p")
  end

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end
