require_relative 'item'

class Weapon 
  attr_reader :name, :damage
  
  def initialize(name, damage, speed)

    @name = name
    @damage = damage
    @speed = speed
  end

end 