class Player
	attr_accessor :name, :health, :coins, :weapon

	def initialize(name, health, coins, weapon)
	  @name = name
	  @health = health
	  @coins = coins
	  @weapon = weapon
	end
	
	def display_player_stats
		puts
		puts "-=-=-=-=-=-=-=-=-"
		puts " Name: #{@name}     "
		puts " Health: #{@health} "
		puts " Coins: #{@coins}   "
		puts " Weapon: #{@weapon}"
		puts "-=-=-=-=-=-=-=-=-"
		puts
	end
end

class Choice
  attr_reader :name, :text, :player, :next_choices, :block

	def initialize
		# no initialize arms required but devs must call setup method. This is to allow choices to be cross-referenced with each other and make their order of creation unimportant.
	end
	
	def setup(name, text, choices, &block)
		@name = name
		@text = text
		@next_choices = choices
		@block = block if block_given?
	end
	
	def trigger_outcome(player)
		puts
		puts @text
		@block.call(player, @next_choices) if @block
	 	
	 	# display available choices
	  	puts "----------------------->>"
	  	@next_choices.each do |choice|
	  		puts ">> #{choice.name}"
		end
		puts
	end
end

class Game
	def initialize(player, initial_choice)
	  @player = player
	  @current_choice = initial_choice
	end

	def run
		display_banner
	    choose_player_name
	    #choose_player_weapon
	    puts "\r (i) Type \"player\" at any time to see your stats."
	    @current_choice.trigger_outcome @player
	    
	    loop do
	      	choice_made = read_choice
	      	case choice_made
		      	when "PLAYER"
		        	@player.display_player_stats if @player
		        next
		      	when "EXIT"
		        break
	      	else
	        	next_choice = @current_choice.next_choices.find {|choice| choice_made == choice.name.upcase }
	        if next_choice
	          @current_choice = next_choice
	          @current_choice.trigger_outcome @player
	          next
	        else
	          puts "Invalid choice."
	        end
	      end
	    end
    end
    
	private

	def read_choice
	  gets.chomp.upcase
	end
	
	def choose_player_name
		puts "You are that warrior. You are vengeful, ferocious and totally shredded."
	    puts "\r What is your name, mighty one?"
	    @player.name = gets.chomp.capitalize
	    puts "\r #{@player.name}, WELCOME TO YOUR DESTINY!"
	end
	
	def choose_player_weapon
		puts "\r A bad-ass warrior needs a bad-ass tool of destruction"
	    puts "\r Massive-Axe | Enchanted-Staff | Wet-Trout"
		loop do 
	   		weapon_chosen = gets.chomp.upcase
		   	case weapon_chosen
		   		when "MASSIVE-AXE"
		   			@player.weapon = "Massive-Axe"
		   			break;
		   		when "ENCHANTED-STAFF"
		   			@player.weapon = "Enchanted-Staff"
		   			break;
		   		when "WET-TROUT"
		   			@player.weapon = "Wet-Trout"
		   			break;
		   	end
		   	puts "That's not an available weapon. Try again!"
	   end
	    puts "\r You have chosen the #{@player.weapon}! Your enemies will be crushed."
	end

	def display_banner

	 	puts "********************************************************"
		puts "                                                        "
		puts "   =------------=               ._-_.                   " 
		puts "   CASTLE RAMSHAW               |_-_(                   "
	 	puts "   =------------=                I                      "
	 	puts "                                /_\\ ___                "
	 	puts "                        ._-_.   |,|/   \\               "
	 	puts "                        |_-_(   | /_____\\       ._-_.  "
		puts "                        I       \\ | u  -| _     |_-_(  "
	 	puts "                       / \\    -_-_-_-_--|/ \\    I     "
		puts "                      /___\\   \\._._._./-|___\\  / \\  "
		puts "                      |_u |    |_   _| -| u_| /___\\    "
		puts "                      |_-_-_-_-_-  U_| -|  _| | u_|     "
		puts "                      |_\._._._./   _|-_-_-_-_-_-_|     "
		puts "                       \\_|-   -|    _|    ..   -|_|    "
		puts "                        \\|-   U|    _| U  ++  U-|/     "
		puts "                         |U   -|  U _|   ____  -|       "
		puts "                         |- _ -|    _|  /|-|- \\-|       "
		puts "                         |-/#\\-|    _|  |-|-|-|-|       "
		puts "                     ,___|_###_|-----'__I|-|-I__|__,    "
		puts "                  ._/ \\/                \\____/    \\,  "
		puts "                 /  \\ \\                  \\```\\   \\,"
		puts "********************************************************"

		puts "There is legend of a warrior, born into servitude but destined to be the great hero his people have needed since the cruel Lord Ramshaw sacked their villages... \r"
	end
end

# DATA INSTANCES
# =======================================================

# PLAYER
player = Player.new("Chris", 100, 1, "Massive-Axe")

# CHOICES
game_over = Choice.new
proceed_to_gate = Choice.new
search_dead_troll = Choice.new
run_past_bridge_troll = Choice.new
kill_bridge_troll = Choice.new
give_troll_coin = Choice.new
cross_drawbridge = Choice.new
start = Choice.new

# CHOICES SETUP
game_over.setup("Complete Game", "Game Over: Would you like to play again?",  [start])
proceed_to_gate.setup("Proceed to Castle Gate", "You cross the bridge and arrive at the castle gates", [game_over])
search_dead_troll.setup("Search Corpse", "You search the body and find 5 gold coins", [proceed_to_gate]) {player.coins += 5}
run_past_bridge_troll.setup("Run Past Troll", "As you attempt to run past the troll, he sticks out a large, granite foot and you fall over... hard. You jump back to your feet, ready to swing your Massive-Axe but the creature has disappeared.\rYou lost 3 health.", [proceed_to_gate]) {player.health -= 3}
kill_bridge_troll.setup("Show Axe Instead", "With a swing of your Massive-Axe, the troll is cleaved in two.", [proceed_to_gate, search_dead_troll]) 
give_troll_coin.setup("Give Only Coin", "You hand over your only coin to this small but solid looking stranger. He shakes his head and laughs at you before disappearing completely.\rYou have no coins left", [proceed_to_gate]) {player.coins -= 1}  
cross_drawbridge.setup("Cross Drawbridge", "You carefully make your way across the drawbridge but a troll appears. While grinning at you, he demands a gold coin.", [give_troll_coin, kill_bridge_troll, run_past_bridge_troll] )
start.setup("Restart Game", "You arrive at the castle entrance.", [cross_drawbridge]) do |player, next_choices|
	next_choices.push(proceed_to_gate) if player.name == "Cheater" unless next_choices.include? proceed_to_gate
end

# GAME
game = Game.new(player, start)
game.run

