require 'rails_helper'

RSpec.describe 'Welcome Index Page' do
  context "a user is not logged in" do
    it "allows the user to log in through Google", :vcr do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]

      visit '/'
      click_on 'Login'

      expect(current_path).to eq('/dashboard')
    end

    it 'has an about section with the idea behind the app' do 
      visit '/'
      
      within '.main-bar' do 
        expect(page).to have_content('About Moon Garden')
      end 
      within '.side-bar-left' do 
        expect(page).to have_content('Moon Garden')
      end 
    end
  end
end