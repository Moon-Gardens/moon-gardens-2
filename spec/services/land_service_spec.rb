require 'rails_helper'

RSpec.describe LandService do
  context '#get_land_data' do
    it 'returns polygon map data', :vcr do
      ll = '38.892062,-77.019912'

      response = LandService.get_land_data(ll)
      expect(response).to be_an Array
      expect(response.first).to be_a Hash
      expect(response.first[:properties]).to be_a Hash
      expect(response.first[:properties][:Name]).to be_a String
    end

    it 'returns multiple names', :vcr do
      ll = '42.588079,-87.822877'

      response = LandService.get_land_data(ll)
      expect(response).to be_an Array
      expect(response.first).to be_a Hash
      expect(response.first[:properties]).to be_a Hash
      expect(response.first[:properties][:Name]).to be_a String
      expect(response[1][:properties][:Name]).to be_a String
      expect(response[2][:properties][:Name]).to be_a String
    end
  end
end
