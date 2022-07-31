class PlantTrackingService
  def self.create_plant(attributes)
    # binding.pry
    response = BaseService.connection.post(
      "/api/v1/users/#{attributes[:user_id]}/gardens/#{attributes[:garden_id]}/plants", 
      _json: attributes.to_json,
      content_type: 'application/json'
    )
    
    BaseService.get_json(response)
  end
end