class ApplicationController < ActionController::API

  def current_user
    if params[:user_id].blank?
      render json: {}, :status => :unauthorized
    else
      User.find(params[:user_id])
    end
  end
end
