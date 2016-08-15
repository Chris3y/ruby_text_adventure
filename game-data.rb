require_relative 'choice'
require_relative 'weapon'
require_relative 'item'
require_relative 'player'
require_relative 'game'

# GAME DATA
# =======================================================

# BANNER_ARRAY
banner = [
"********************************************************",
"                                                        ",
"                                ._-_.                   ",
"                                |_-_(                   ",
"                                 I                      ",
"                                /_\\ ___                ",
"                        ._-_.   |,|/   \\               ",
"      REVENGE AT        |_-_(   | /_____\\       ._-_.  ",
"  =----------------=    I       \\ | u  -| _     |_-_(  ",
"    CASTLE RAMSHAW     / \\    -_-_-_-_--|/ \\    I     ",
"                      /___\\   \\._._._./-|___\\  / \\  ",
"                      |_u |    |_   _| -| u_| /___\\    ",
"                      |_-_-_-_-_-  U_| -|  _| | u_|     ",
"                      |_\\._._._./   _|-_-_-_-_-_-_|    ",
"                       \\_|-   -|    _|    ..   -|_|    ",
"                        \\|-   U|    _| U  ++  U-|/     ",
"                         |U   -|  U _|   ____  -|       ",
"                         |- _ -|    _|  /|-|- \\-|      ",
"                         |-/#\\-|    _|  |-|-|-|-|      ",
"                     ,___|_###_|-----'__I|-|-I__|__,    ",
"                  ._/ \\/                \\____/    \\, ",
"                 /  \\ \\                  \\```\\   \\,",
"********************************************************",
"There is legend of a warrior, born into servitude but destined to be the great hero the people have needed since the cruel Lord Ramshaw sacked their villages...",
"",
"You are that warrior. You are vengeful, ferocious and totally shredded.",
]

# PLAYER # ---------------------------------------------------------------------

player1 = Player.new(100,1)

# ITEMS # ----------------------------------------------------------------------

golden_locket = Item.new

# WEAPONS # --------------------------------------------------------------------

weapons = [
  Weapon.new("Battle-Axe", 90, 10),
  Weapon.new("Broad-Sword", 70, 30),
  Weapon.new("War-Scythe", 40, 60),
  ]

# CHOICES # --------------------------------------------------------------------

start = Choice.new
restart = Choice.new
death = Choice.new;

march_territory = Choice.new  
cross_rope_bridge = Choice.new
take_locket = Choice.new
kill_guards = Choice.new
spare_guards = Choice.new
search_guard_corpses = Choice.new

give_troll_coin = Choice.new
kill_bridge_troll = Choice.new
run_past_bridge_troll = Choice.new
proceed_to_gate = Choice.new
recross_rope_bridge = Choice.new
not_enough_toll_money = Choice.new
climb_back_rope_bridge_start = Choice.new
game_over = Choice.new

use_locket = Choice.new

# Data # -----------------------------------------------------------------------

def use_item(item)
   item.use_states
end

golden_locket.setup("golden", "% Locket", "A golden locket from your village with an inscription of a bat on the back.", "You cannot use the locket here.", "The locket is glowing as you take it out of your pocket. The winged creature screeches at the sight of it and retreats further into the air. You wear the locket around your neck and the creature flys off immediately. It must be some sort of deterrent those guards were using.", [use_locket])
use_locket.setup("USE", "% locket.", "You put the locket on, don't you look pretty?", [])

# Start
start.setup("start", "% game.", "Soaked in the blood of the armies that dared pillage your homeland, you clench your teeth and push forward.", [march_territory])
restart.setup("get", "% up.", "You mysteriously awake far back in your journey with your health restored, as if it were all some wonderfully violent dream. And yet, you still have items collected from the bloody quest you remember. There is some magic at work here, perhaps a sign from the gods your quest of vengengence is righteous!", [start])
death.setup("", "", "Will you continue?", [restart])

# Guards
march_territory.setup("march","% into Lord Ramshaw's territory.", "As you approach the permiter of Lord Ramshaw's territory, you see two of his guards nervously standing their posts, watching you appoach. The sight of your enormous mass is intimidating enough but then, they realise who you are and why you're here. One of them says with a quiver in his voice: \r\n\r\n \"I know you, you're... <%=@player%>! Please sir, we heard what you did to Lord Ramshaw's armies. We have families. Please spare us, I beg you! We had nothing to do with the raid on your villages, I swear!\" \r\n\r\n Despite their pathetic begging, you can hear insincerity in their voice.", [kill_guards, spare_guards]) {|player, next_choices|  next_choices.push(proceed_to_gate) if player.name == "Cheater" unless next_choices.include? proceed_to_gate}
kill_guards.setup("crush", "% them! They are part of the wicked machine, after-all", "After contemplating for a moment, you raise your <%=@player.weapon%> and bring it down, on the first guards should severing his arm. While he screams and bleeds out, you take his severed limb and beat his comrade to a bloody pulp with it. As you do, a locket with the unmistakable craftsmenship of your village falls out of his pocket. Those scoundrels didn't just support the injustice against your people, they perpetrated it!", [cross_rope_bridge, search_guard_corpses]) {|player, next_choices| player.kill_count +=2}
spare_guards.setup("spare", "% them. They aren't who you came here for.", "After contemplating for a moment, you gesture to the road. The men don't hesitate and run as fast as their legs will carry them. As they do, one of them drops a locket, the craftsmanship is unmistakably from your village. Those scoundrels weren't innocent after all! Your fury grows.", [cross_rope_bridge, take_locket])
search_guard_corpses.setup("search", "% their wretched corpses.", "As you dig through the mess, you find some coins that bare your village insignia. You gain 5 gold coins", [take_locket, cross_rope_bridge]){|player, next_choices| player.coins +=5}
take_locket.setup("take", "% the locket.", "As you pick up the golden locket you notice a bat inscribed on the back. It's not clear what this is for.", [cross_rope_bridge]) {|player, next_choices| player.inventory.push(golden_locket)}

# Rope bridge
cross_rope_bridge.setup("cross","% rope bridge.", "You stridently make your way across the rope bridge but a figure pops into view. It appears to be some sort of troll. You proceed forward more cautiously as these can be dangerous foes. As you get closer you see that's the has is grinning at you. \r\n\r\n \"This my bridge... pay gold coin to cross. You no pay... I smash.\"", [give_troll_coin, kill_bridge_troll, run_past_bridge_troll] )
recross_rope_bridge.setup("attempt", "% to cross the rope bridge again.", "You cautiously make your way across the rope bridge. The air on the bridge appears to liquify and suddely, the troll is standing there again, his grin perhaps even more annoying than the last time. \r\n\r\n\"This my bridge... OH! It's YOU!? You now pay <%=@player.rope_bridge_toll%> gold... or I smash!", [kill_bridge_troll, give_troll_coin, run_past_bridge_troll]) {|player, next_choices| if player.coins < player.rope_bridge_toll and not next_choices.include? not_enough_toll_money then next_choices.shift; next_choices.push not_enough_toll_money end}
give_troll_coin.setup("yield","% to the troll and hand over <%=@player.rope_bridge_toll%> coin.", "You hand over <%=@player.rope_bridge_toll%> coin to this small but solid looking stranger. He shakes his head and sniggers at you before disappearing completely into thin air. The sounds of his laughter still lingers... oddly.", [proceed_to_gate]) {|player, next_choices| player.coins -= player.rope_bridge_toll}  
kill_bridge_troll.setup("give","% the business side of your <%=@player.weapon%> instead!", "You swing the <%=@player.weapon%> at the troll who doesn't move an inch. The blade of the weapons cuts cleanly through him and yet... he his unharmed! This is some sort of magical troll! His stupid grin turns into an almost deliberate cackle. He put out a hand and touches the rope rail you're holding onto. The bridge appears to turn to liquid and you fall through it, crashing onto the rocks below. \r\n\r\nYou lost 70 health.", [climb_back_rope_bridge_start]) {|player, next_choices| player.health -= 70; player.rope_bridge_toll *= 2}
run_past_bridge_troll.setup("run","% past the troll.", "You attempt to run past the troll and he simply touches the rope bannister of the bridge which suddenly turns to the entire thing to a type of liquid, that you immediately fall right through... hard. \r\n\r\nYou lost 65 health.", [climb_back_rope_bridge_start]) {|player, next_choices| player.health -= 65; player.rope_bridge_toll *= 2}
climb_back_rope_bridge_start.setup("climb", "% back to up to the bridge entrance.", "Slowly, you make your way up the ravine wall. The climb is difficult and frustrating with your injuries. You grow more angry at the thought of the troll.\r\n\r\nEventually, you reach the rope bridge again.", [recross_rope_bridge])
not_enough_toll_money.setup("show", "% the troll you don't have enough money.", "You show the troll you have <%=@player.coins%> coins. His annoying grin grows even wider... \r\n\r\n\"No problem... half your health will do.\" \r\n\r\nYou feel a tremendous pain suddenly and the troll disappears, cackling louder than ever. \r\n\r\nYou lost half of your health and any coins you had.", [proceed_to_gate]) {|player, next_choices| player.health = (player.health / 2).ceil; player.coins = 0;}

proceed_to_gate.setup("proceed","% to Castle Gate.", "You cross the bridge and arrive at the castle gates", [game_over])
game_over.setup("complete", "% Game.", "Game Over: Would you like to play again?", [start])

# GAME
game = Game.new(banner, start, death, player1, weapons)
game.run
