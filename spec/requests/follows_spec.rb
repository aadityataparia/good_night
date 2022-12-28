require 'rails_helper'

RSpec.describe 'Follows API', type: :request do
  before do 
    @user = User.create(name: "Aadi")
    @user2 = User.create(name: "Michel")
  end

  describe 'POST /follows' do
    it 'follows user' do
      expect { post '/follows', params: { following_id: @user2.id, user_id: @user.id } }.to change(Follow, :count).by(1)
      expect(@user.followings.include?(@user2))
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /follows' do
    it 'unfollows user' do
      @user.follow(@user2.id)
      expect(@user.followings.include?(@user2))

      delete '/follows', params: { following_id: @user2.id, user_id: @user.id }
      expect not(@user.followings.include?(@user2))
      expect(response).to have_http_status(200)
    end

    it 'returns error if doesn\'t follow user' do
      expect not(@user.followings.include?(@user2))

      delete '/follows', params: { following_id: @user2.id, user_id: @user.id }
      expect not(@user.followings.include?(@user2))
      expect(response).to have_http_status(404)
    end
  end
end
