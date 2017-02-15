require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do  # User should see a generic landing page w/ login, signup options to start
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Finer Things Club: A Sinatra App")
      expect(last_response.body).to include("Sign Up")
      expect(last_response.body).to include("Login")
    end
  end
end
