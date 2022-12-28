class FollowsController < ApplicationController
  def create
    if current_user.follow(params[:following_id])
      render json: { status: :success, message: 'Follow successful' }
    else
      render json: { status: :error, error: follow.errors.full_messages.join(', ') }, status: 400
    end
  end

  def delete
    follow = current_user.unfollow(params[:following_id])
    if follow
      render json: { status: :success, message: 'Unfollow successful' }
    else
      render json: { status: :error, error: 'User does not follow the user' }, status: 404
    end
  end
end
