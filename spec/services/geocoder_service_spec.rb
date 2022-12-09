require 'rails_helper'

RSpec.describe GeocoderService do
  context '#get_coordinates' do
    it 'returns latitude and longitude', :vcr do
      location = 'Washington,DC'
      response = GeocoderService.get_coordinates(location)
      expect(response).to be_a Hash
      expect(response[:results]).to be_an Array
      expect(response[:results].first[:locations].first[:latLng][:lat])
      .to be_a Float
      expect(response[:results].first[:locations].first[:latLng][:lng])
      .to be_a Float
    end
  end
end
