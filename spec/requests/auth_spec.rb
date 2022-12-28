require 'rails_helper'

RSpec.describe 'Basic auth', type: :request do
  describe 'GET /' do
    it 'throws 401 if no user given' do
      get '/clock_ins'
      expect(response).to have_http_status(401)
    end
  end
end