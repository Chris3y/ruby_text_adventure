require_relative 'choice'
require_relative 'weapon'
require_relative 'item'
require_relative 'player'
require 'erb'

class Game

  def initialize(banner, initial_choice, death_choice, player, weapons)
    @banner = banner
    @current_choice = initial_choice
    @death_choice = death_choice
    @player = player
    @weapons = weapons
  end

  def run
    # display title banner
    draw_ascii_art(@banner)
    
    # setup player object based partly on choices
    @player = Player.new(choose_player_name, choose_player_weapon(@weapons), @player.health, @player.coins)
    if @player.name.upcase  == "CHRIS" 
      @player.health + 25; puts "\r\n AWESOME NAME BONUS: +25 Health Boost!";
    end

    puts "\r\n #{@player.name}, Welcome to your DESTINY!"
    puts
    # display game-play tips     
    puts "(i) Type \"player\" at any time to see your stats."
    puts "(i) Choose an action by entering the VERB (always shown in capitals)."
    # display initial choice outcome
    display_choice_text(@current_choice, @player)
    display_next_choices(@current_choice)

    # GAME LOOP
    # *******************************
    loop do
      choice_made = gets.chomp.upcase
      # hand various expect inputs 
      case choice_made
      when "PLAYER"
        display_player_stats
        next      
      when "EXIT"
        puts "Are you SURE you want to chicken out? (\"Y\" to confirm)"        
      else
          next_choice = @current_choice.next_choices.find {|choice| choice_made == choice.verb.upcase }
          inventory_choice = @player.inventory.find {|choice| choice_made == choice.verb.upcase }
      end

      if inventory_choice
        @current_choice = inventory_choice
        display_choice_text(@current_choice, @player)
        next
      end
     
      if next_choice
        @current_choice = next_choice
        display_choice_text(@current_choice, @player)
        
        if player_alive?(@player) 
           display_next_choices(@current_choice)
        else
           display_death
           @current_choice = @death_choice
           display_choice_text(@current_choice, @player)
           display_next_choices(@current_choice)
           @player.health = 100
        end

      else next_choice and inventory_choice
        puts "Invalid choice. Wipe the blood and sinew from your eyes and try again."
      end 

    end
  end

  private
  
  def choose_player_name
    puts "\r\n What is your name, mighty one?"
    name_entered = gets.chomp.capitalize
    forbidden_names = ["RAMSHAW", "JONATHAN", "JON", "JOHN", "JONNY", "JOHNY", "JAY"]

    if forbidden_names.include? name_entered.upcase
      puts
      puts "YOU MUST NOT USE FORBIDDEN NAMES! Your name is now \"Melvin\"."
      name_entered = "Melvin"  
    end
    name_entered
  end
  
  def choose_player_weapon(weapons)
    puts "\r\n A bad-ass warrior needs an equally bad-ass instrument of destruction."
    puts "Choose your tool: \r\n "
    weapons.each_with_index do |weapon, i|  
      puts "  >> #{i + 1}: #{weapon.name}"
    end
    
    loop do 
      weapon_index_chosen = gets.chomp.upcase.to_i
      if weapon_index_chosen < 1 || weapon_index_chosen > weapons.size
        puts "Even YOU will not want to face this challenge unarmed. Choose a valid number."
        next
      end
      puts "\r\n You selected #{weapons[weapon_index_chosen - 1].name}. A fine choice! It's time to crush your enemies with it..."
      return weapons[weapon_index_chosen - 1]   
    end
  end
  
  def display_choice_text(choice, player)
    puts
    puts "++-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-++"
    puts
    # display choice text and interpolate any passed variables at print time using erb
    renderer = ERB.new(choice.text)
    puts renderer.result(binding)
    choice.block.call(player, choice.next_choices) if choice.block
    
    puts "\r\n..."
    gets
  end

  def display_next_choices(choice)
   # display available choices
      choice.next_choices.each do |next_choice|
        renderer = ERB.new(next_choice.name)
        puts " >> #{renderer.result(binding)}"
      end
      puts
  end

  def player_alive?(player)
    # If this choice kills player, display death
    (player.health <= 0) ? false : true  
  end

  def display_death
    death_array = [
    "This choice left you with no more health, you died a gruesome and inglorious death.",
    "Well, you messed up and now you're dead. I hope you learned something.",
    "You're dead. Time to visit the great blood-thirsty warrior in the sky.",
    ]
    puts 
    puts death_array[rand(death_array.count)]
    puts
    puts "  ▄▄ •  ▄▄▄· • ▌ ▄ ·. ▄▄▄ .           ▌ ▐·▄▄▄ .▄▄▄   "
    puts " ▐█ ▀ ▪▐█ ▀█ ·██ ▐███▪▀▄.▀·    ▪     ▪█·█▌▀▄.▀·▀▄ █· "
    puts " ▄█ ▀█▄▄█▀▀█ ▐█ ▌▐▌▐█·▐▀▀▪▄     ▄█▀▄ ▐█▐█•▐▀▀▪▄▐▀▀▄  "
    puts " ▐█▄▪▐█▐█ ▪▐▌██ ██▌▐█▌▐█▄▄▌    ▐█▌.▐▌ ███ ▐█▄▄▌▐█•█▌ "
    puts " ·▀▀▀▀  ▀  ▀ ▀▀  █▪▀▀▀ ▀▀▀      ▀█▄▀▪. ▀   ▀▀▀ .▀  ▀ "      
    puts
  end
  
  def display_player_stats
    puts
    puts "-=- #{@player.name} =-=-=-=-=-=-=-=-=-"
    puts " Health: #{@player.health} "
    puts " Coins: #{@player.coins}   "
    puts " Kill Count: #{@player.kill_count}"
    puts " Weapon: #{@player.weapon}"
    puts "-=-=-=-=-=-=-=-=-=-=-"
    puts
    puts "--- Inventory ---"
    
    puts #{ @player.inventory.length}
    if @player.inventory.any? then
        @player.inventory.each do |i|
          puts "#{i.name}"
        end
      else
     puts "You have no items" 
    end
    
    puts
  end

  def draw_ascii_art(banner)
    banner.each do |line|
      puts line
    end    
  end
  
end
