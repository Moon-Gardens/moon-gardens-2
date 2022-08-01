module MoonHelper
  def self.rec(phase)
    moon_phase = phase.downcase

    if moon_phase.include?('dark')
      'Plant crops which produce seeds outside the fruit (grains, spinach, cauliflower, cabbage, broccoli, celery and lettuce).'
    elsif moon_phase.include?('waxing')
      'Plant crops with seeds inside the fruit (beans, peppers, tomatoes, squash and melons).'
    elsif moon_phase.include?('full')
      "Root vegetables, such as carrots, beets, onions and potatoes, will flourish. It's also a good time to transplant seedlings or to prune."
    elsif moon_phase.include?('waning')
      'Avoid planting and focus on fertilizing the soil. This is the best time to mow grass, harvest, transplant and prune.'
    else
      "Interesting, this is a moon we don't have anything for! We will work on that!"
    end
  end
end