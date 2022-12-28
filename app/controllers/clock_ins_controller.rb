class ClockInsController < ApplicationController
  def index
    clock_ins = current_user.clock_ins
    render json: clock_ins.to_json
  end

  def feed
    render json: current_user.feed.to_json
  end

  def create
    clock_in = current_user.clock_in(params[:from], params[:to])
    if clock_in.errors.size == 0
      render json: { status: :success, message: 'Clock in successful' }
    else
      render json: { status: :error, message: clock_in.errors.full_messages.join(', ') }, status: 400
    end
  end
end
