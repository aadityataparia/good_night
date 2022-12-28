require 'rails_helper'

RSpec.describe 'ClockIns API', type: :request do
  before do
    @user = User.create(name: "Aadi")
  end

  describe 'POST /clock_ins' do
    it 'creates a new clock in record' do
      expect { post '/clock_ins', params: {
        user_id: @user.id,
        from: Time.now() - 1.day,
        to: Time.now()
      } }.to change(ClockIn, :count).by(1)
      expect(response).to have_http_status(200)
    end

    it 'fail without from' do
      post '/clock_ins', params: {
        user_id: @user.id,
        to: Time.now()
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["message"]).to eq("From can't be blank")
    end

    it 'fail without to' do
      post '/clock_ins', params: {
        user_id: @user.id,
        from: Time.now()
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["message"]).to eq("To can't be blank")
    end

    it 'fail when to < from' do
      post '/clock_ins', params: {
        user_id: @user.id,
        from: Time.now() + 1.day,
        to: Time.now()
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["message"]).to eq("To time should be greater than from time")
    end
  end

  describe 'GET /clock_ins' do
    it 'gets users clockins sorted by created at' do
      ci_1 = @user.clock_in(Time.now() - 1.day, Time.now())
      ci_2 = @user.clock_in(Time.now() - 1.day, Time.now())

      get '/clock_ins', params: {
        user_id: @user.id
      }
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)
      expect(body.size).to eq(2)
      expect(body[0]["id"]).to eq(ci_2.id)
      expect(body[1]["id"]).to eq(ci_1.id)
    end
  end

  describe 'GET /feed' do
    it 'returns expected clockins' do
      michael = User.create(name: "michael")
      archer  = User.create(name: "archer")
      lana    = User.create(name: "lana")

      michael.follow(lana.id)
    
      ci_1 = michael.clock_in("2019-01-01", "2019-01-02")
      ci_2 = archer.clock_in("2020-01-01", "2020-01-02")
      ci_3 = lana.clock_in("2021-01-01", "2021-01-03")
      ci_4 = lana.clock_in("2021-01-01", "2021-01-05")
      ci_past = lana.clock_in("2021-01-01", "2021-01-02")
      ci_past.created_at = DateTime.now - 7.days - 1.second
      ci_past.save

      get '/feed', params: {
        user_id: michael.id
      }

      feed = JSON.parse(response.body)
      ids = feed.map{ |f| f["id"] }
      
      assert ids.include?(ci_1.id)
      assert ids.include?(ci_3.id)
      assert ids.include?(ci_4.id)
      assert_not ids.include?(ci_2.id)
      assert_not ids.include?(ci_past.id)

      # check order from duration
      assert ids[0].equal?(ci_4.id)
      assert ids[1].equal?(ci_3.id)
    end
  end
end
