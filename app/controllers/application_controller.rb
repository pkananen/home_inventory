class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
  	sign_out
  	super
  end

  # Probably overkill currently, but the authentication system could become
  # more complicated in the future.
  def check_correct_user(user)
  	current_user?(user)
  end
end
