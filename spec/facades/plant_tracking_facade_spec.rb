require 'rails_helper'

RSpec.describe PlantTrackingFacade do
  before do
    @user_hash =
    { 'name' => 'Jennifer Halloran',
      'email' => 'frankfurters@weinermobile.com',
      'unverified_email' => 'frankfurters@weinermobile.com',
      'email_verified' => true,
      'first_name' => 'Jennifer',
      'last_name' => 'Halloran',
      'image' => 'https://lh3.googleusercontent.com/a-/AFdZucr_zffBdhJaydFkdXeeHkhe2BzmVNKGIE-Ozwvh=s96-c' }

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
      "name": 'Carrot',
      "plant_id": 'sae2340987dage',
      "moon_phase": 'waxing crescent',
      "date_planted": Date.new,
      "date_matured": Date.new,
      "bounty_amount": 23,
      "pruning_behaviors": 'No pruning, only thinning',
      "notes": 'Magic carrots matured on the same day they were planted!'
    }
    @plant = PlantTrackingFacade.create_plant(@plant_hash)
  end

  it 'returns a plant object', :vcr do
 

    expect(@plant).to be_an_instance_of(PlantTracking)
    expect(@plant.name).to eq('Carrot')
  
    PlantTrackingFacade.destroy_plant(@user_response[:data][:id], @garden_response[:data][:id],
      @plant.id)
    GardenFacade.destroy_garden(@user_response[:data][:id], @garden_response[:data][:id])
  end

  it 'returns the users saved plant information for a specific garden', :vcr do
    response = PlantTrackingFacade.get_plants(@user_response[:data][:id], @garden_response[:data][:id])

    expect(response).to be_all(PlantTracking)

    PlantTrackingFacade.destroy_plant(@user_response[:data][:id], @garden_response[:data][:id],
      @plant.id)
    GardenFacade.destroy_garden(@user_response[:data][:id], @garden_response[:data][:id])
  end

  it 'deletes a plant', :vcr do

    count_1 = PlantTrackingFacade.get_plants("#{@user_response[:data][:id]}", "#{@garden_response[:data][:id]}").count
    response_2 = PlantTrackingFacade.destroy_plant(@user_response[:data][:id], @garden_response[:data][:id],
      @plant.id)

    count_2 = PlantTrackingFacade.get_plants("#{@user_response[:data][:id]}", "#{@garden_response[:data][:id]}").count
    expect(count_1 - 1).to eq(count_2)

    GardenFacade.destroy_garden(@user_response[:data][:id], @garden_response[:data][:id])
  end

  it 'edits a plant', :vcr do

    plant_hash_2 =
      {
        "name": 'Hot Dawgs'
      }

    plant_2 = PlantTrackingFacade.edit_plant("#{@user_response[:data][:id]}", "#{@garden_response[:data][:id]}",
                                             @plant.id, plant_hash_2)
    expect(@plant).to be_an_instance_of(PlantTracking)
    expect(plant_2.id).to be_an_instance_of(String)
    expect(plant_2.name).to eq('Hot Dawgs')

    PlantTrackingFacade.destroy_plant(@user_response[:data][:id], @garden_response[:data][:id],
      @plant.id)
    GardenFacade.destroy_garden(@user_response[:data][:id], @garden_response[:data][:id])
  end
end
