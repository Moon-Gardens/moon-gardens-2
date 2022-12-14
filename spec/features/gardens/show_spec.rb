require 'rails_helper'

RSpec.describe 'garden show page' do
  before do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]


    @user = JSON.parse(File.read('spec/fixtures/user.json'), symbolize_names: true)
    @gardens = JSON.parse(File.read('spec/fixtures/gardens.json'), symbolize_names: true)
    @plants = JSON.parse(File.read('spec/fixtures/plants.json'), symbolize_names: true)
    @hotdog_garden = JSON.parse(File.read('spec/fixtures/hotdog_garden.json'), symbolize_names: true)
    @moon = JSON.parse(File.read('spec/fixtures/moon.json'),symbolize_names: true)
    @weather = JSON.parse(File.read('spec/fixtures/weather.json'), symbolize_names: true)
    @ip = JSON.parse(File.read('spec/fixtures/ip.json'), symbolize_names: true)


    allow(UserService).to receive(:find_or_create_user).and_return(@user)
    allow(GardenService).to receive(:get_gardens).and_return(@gardens)
    allow(PlantTrackingService).to receive(:get_plants).and_return(@plants)
    allow(GardenService).to receive(:get_garden_info).and_return(@hotdog_garden)
    allow(MoonService).to receive(:get_moon_data).and_return(@moon)
    allow(WeatherService).to receive(:get_weather).and_return(@weather)
    allow(IpService).to receive(:get_ip_location).and_return(@ip)
    allow_any_instance_of(ApplicationController).to receive(:ip_address).and_return("24.164.247.195")
  end
  context 'a user is logged in' do
    before do 
      visit '/'
      click_on 'Login'
      visit '/gardens/339'
    end 
    it 'has header links to dashboard, logout, and landing page' do
      expect(page).to have_link('My Garden')
      expect(page).to have_link('Logout')
      expect(page).to have_link('About')
    end

    it 'displays the moon phase data' do
      expect(page).to have_content('Illumination')
      expect(page).to have_content('Plant crops with seeds inside the fruit (beans, peppers, tomatoes, squash and melons).')
      expect(page).to have_content('Bread Moon')
    end

    it "displays the corresponding garden's name" do
      expect(current_path).to eq('/gardens/339')
      expect(page).to have_content('Hot Dog Garden')
      expect(page).to_not have_content('Mustard Garden')
    end

    it "displays the garden's information" do
      expect(page).to have_content('North')
      expect(page).to have_content('definitely gmo')
    end

    it "has a button to search for plants to add" do
      expect(page).to have_button("Find Plants to add to Garden")
    end
    
    it "displays the plants in the corresponding garden" do
      expect(page).to have_content("Catsup")
      expect(page).to have_content("Sturd")
      
      within ".plant-142" do
        expect(page).to have_content("Waxing Crescent")
        expect(page).to have_content("23")
        expect(page).to have_content("No pruning, only thinning")
        expect(page).to have_content("Magic tomatoes matured on the same day they were planted!")
        expect(page).to have_button("Add Tracking Info")
        expect(page).to have_button("Remove Plant")
      end

      within ".plant-143" do
        expect(page).to have_content("Waning Crescent")
        expect(page).to have_content("1000000")
        expect(page).to have_content("Can't trim the sturd!!!")
        expect(page).to have_content("English, honey, dijon, and spicayy")
        expect(page).to have_button("Add Tracking Info")
        expect(page).to have_button("Remove Plant")
      end
    end
  end

  context 'a visitor is not logged in' do
    it "redirects a visitor to the dashboard" do     
      visit '/gardens/339'
      expect(current_path).to eq('/')
      expect(page).to have_content("Oopsy daisy! Please log in below to view that page.")
    end
  end
end
