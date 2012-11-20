class ApplicationController < ActionController::Base
  protect_from_forgery

  def sponsored
    Branch.sponsored_branched.limit(4)
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || user_path(current_user)
  end

  helper_attr :sponsored
end
