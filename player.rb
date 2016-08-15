class Player
  attr_accessor :name, :health, :coins, :weapon, :kill_count, :rope_bridge_toll, :inventory

  def initialize(name = "", weapon = nil, health, coins)
    @name = name
    @weapon = weapon
    @health = health
    @coins = coins
    @kill_count = 0
    @rope_bridge_toll = 1
    @inventory = []
  end

  def to_s
     @name
  end

end