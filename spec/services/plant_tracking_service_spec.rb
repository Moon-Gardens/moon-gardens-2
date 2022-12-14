require 'rails_helper'

RSpec.describe PlantTrackingService do
  before do 
    @user_hash =
      {
        'name' => 'Jennifer Halloran',
        'email' => 'frankfurters@weinermobile.com',
        'unverified_email' => 'frankfurters@weinermobile.com',
        'email_verified' => true,
        'first_name' => 'Jennifer',
        'last_name' => 'Halloran',
        'image' => 'https://lh3.googleusercontent.com/a-/AFdZucr_zffBdhJaydFkdXeeHkhe2BzmVNKGIE-Ozwvh=s96-c'
      }

    @user_response = UserService.find_or_create_user(@user_hash)

    @garden_hash =
      {
        "user_id": "#{@user_response[:data][:id]}",
        "name": 'Summer Garden',
        "notes": "it's too damn hot",
        "cardinal_direction": 1
      }

    @garden_response = GardenService.create_garden(@garden_hash)

    @plant_hash =
    {
      "user_id": "#{@user_response[:data][:id]}",
      "garden_id": "#{@garden_response[:data][:id]}",
      "name": "Carrot",
      "plant_id": "sae2340987dage",
      "moon_phase": "waxing crescent",
      "date_planted": Date.new,
      "date_matured": Date.new,
      "bounty_amount": 23,
      "pruning_behaviors": "No pruning, only thinning",
      "notes": "Magic carrots matured on the same day they were planted!"
    }

    @response = PlantTrackingService.create_plant(@plant_hash)
  end 
  it 'passes plant info from the user', :vcr do
    expect(@response).to be_a Hash
    expect(@response[:data]).to be_a Hash
    expect(@response[:data]).to have_key :id
    expect(@response[:data][:attributes]).to have_key :name
    expect(@response[:data][:attributes]).to have_key :plant_id
    expect(@response[:data][:attributes]).to have_key :notes
    expect(@response[:data][:attributes]).to have_key :date_planted
    expect(@response[:data][:attributes]).to have_key :date_matured
    expect(@response[:data][:attributes]).to have_key :bounty_amount
    expect(@response[:data][:attributes]).to have_key :pruning_behaviors
    expect(@response[:data][:attributes]).to have_key :moon_phase

    PlantTrackingFacade.destroy_plant(@user_response[:data][:id], @garden_response[:data][:id], @response[:data][:id])
    GardenFacade.destroy_garden(@user_response[:data][:id], @garden_response[:data][:id])
  end

  it 'displays the users saved plant information for a specific garden', :vcr do

    @plants = PlantTrackingService.get_plants(@user_response[:data][:id], @garden_response[:data][:id])
    expect(@plants[:data]).to be_an(Array)
    expect(@plants[:data].first).to have_key(:id)
    expect(@plants[:data].first).to have_key(:type)
    expect(@plants[:data].first).to have_key(:id)
    expect(@plants[:data].first[:attributes]).to have_key(:name)
    expect(@plants[:data].first[:attributes]).to have_key(:plant_id)
    expect(@plants[:data].first[:attributes]).to have_key(:date_planted)
    expect(@plants[:data].first[:attributes]).to have_key(:date_matured)
    expect(@plants[:data].first[:attributes]).to have_key(:moon_phase)
    expect(@plants[:data].first[:attributes]).to have_key(:bounty_amount)
    expect(@plants[:data].first[:attributes]).to have_key(:pruning_behaviors)
    expect(@plants[:data].first[:attributes]).to have_key(:name)
    expect(@plants[:data].first[:attributes]).to have_key(:garden_id)

    PlantTrackingFacade.destroy_plant(@user_response[:data][:id], @garden_response[:data][:id], @response[:data][:id])
    GardenFacade.destroy_garden(@user_response[:data][:id], @garden_response[:data][:id])
  end

  it 'deletes a plant', :vcr do

    count = PlantTrackingService.get_plants("#{@user_response[:data][:id]}", "#{@garden_response[:data][:id]}")[:data].count

    PlantTrackingFacade.destroy_plant(@user_response[:data][:id], @garden_response[:data][:id], @response[:data][:id])
    count_2 = PlantTrackingService.get_plants("#{@user_response[:data][:id]}", "#{@garden_response[:data][:id]}")[:data].count

    expect(count - 1).to eq(count_2)
    GardenFacade.destroy_garden(@user_response[:data][:id], @garden_response[:data][:id])
  end

  it 'can edit a plant', :vcr do

    plant_data = PlantTrackingService.get_plants("#{@user_response[:data][:id]}", "#{@garden_response[:data][:id]}")[:data]

    plant_1 = plant_data[0]
    name = plant_1[:attributes][:name]

    @plant_hash =
    {
      "name": "Hot Dawgs"
    }

    response_2 = PlantTrackingService.edit_plant("#{@user_response[:data][:id]}", "#{@garden_response[:data][:id]}", "#{plant_1[:id]}", @plant_hash)

    plant_data_2 = PlantTrackingService.get_plants("#{@user_response[:data][:id]}", "#{@garden_response[:data][:id]}")[:data]

    plant_3 = plant_data_2.find do |plant|
      plant[:id] == plant_1[:id]
    end
    expect(plant_3[:attributes][:name]).to eq("Hot Dawgs")
    
    PlantTrackingFacade.destroy_plant(@user_response[:data][:id], @garden_response[:data][:id], @response[:data][:id])
    GardenFacade.destroy_garden(@user_response[:data][:id], @garden_response[:data][:id])
  end
end
