class ApplicationController < ActionController::API
  class NotAuthorized < StandardError
  end

  rescue_from ApplicationController::NotAuthorized do |exception|
    render status: :unauthorized
  end

  def current_user
    raise ApplicationController::NotAuthorized if not params[:user_id]
    user = User.find(params[:user_id])
    raise ApplicationController::NotAuthorized if not user
    user
  end
end
