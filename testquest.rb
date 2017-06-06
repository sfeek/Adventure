require './Adventure'

class Locations
#******************
#* Required stuff *
#******************

    # Intialization of the locations class at startup
    def initialize()
        @game = Game.new

        puts "Enter a Username to get started: "
        @game.set_user_name(gets.chomp.downcase)

        if @game.load
            # Set the initial game items and locations for a new game
            @game.screen "\nStarting New Game...\n\n"
            @game.screen "Welcome to the land of Test! You are on a short mission to demonstrate the Adventure game library. Please feel free to roam and watch out for voids!\n"
            
            @game.set_location(0,0,0)
            @game.set_location_attribute("Light Switch","OFF")

            @game.set_location(0,1,0)
            @game.set_location_attribute("Berries",4)
            
            @game.set_location(0,2,0)
            @game.add_location_item("Scrap of Paper")

            @game.set_location(2,2,0)
            @game.add_location_item("Small Dagger")
            
            @game.set_location(1,2,0)
            @game.add_location_item("Piece of Glass")
            
            @game.set_location(0,3,0)
            @game.add_location_item("Old Lighter")
            
            @game.set_location(3,2,1)
            @game.add_location_item("Rusty Key")
            @game.set_npc_attribute(0,"Health",100)
            @game.set_npc_attribute(0,"Max Hit", 30)
            @game.add_location_npc(0)

            @game.set_player_attribute("Lives",3)
            @game.set_player_attribute("Health",100)
            @game.set_player_attribute("Max Hit",10)

            @game.set_location(0,1,0)

        else
            # Player loaded an existing game
            @game.screen "\nGame Loaded!\n\n"
        end
    end

    # Start where we left off
    def get_next_location
        return @game.next_location
    end

#*********************************************************
#* Grid Locations - Function Name Format: location_x_y_z *
#*********************************************************

    # Small dark room with a Safe
    def location_0_0_0
        @game.set_location(0,0,0)

        if @game.check_inventory_item("Rusty Key")
            if @game.get_location_attribute("Light Switch") == "OFF"
                @game.screen "You are in a small dark room. You see a light switch on the wall. There is something large and metal on the floor."
                obj = "2. Inspect the large metal object"
            else
                @game.screen "You are in a small brightly lit room. You see a light switch on the wall. There is a large safe on the floor."
                obj = "2. Inspect the safe"
            end

            while true
                case @game.show_menu ["1. Flip light switch","#{obj}","3. Leave the room"]
                when "1"
                    @game.set_location_attribute("Light Switch", @game.toggle(@game.get_location_attribute("Light Switch")))
                    if @game.get_location_attribute("Light Switch") == "ON" 
                        @game.screen "The light is on!"
                        return @game.next_location
                    else
                        @game.screen "The light is off!"
                        return @game.next_location
                    end

                when "2"
                    if @game.get_location_attribute("Light Switch") == "ON"
                        if @game.check_inventory_item("Scrap of Paper")
                            if @game.check_inventory_item("Piece of Glass")
                                @game.screen "You are clever and used your small piece of glass like a magnifier to read the combination from the scrap of paper. The safe opens easily."
                            else
                                @game.screen "You have a small scrap of paper with what you think is the combination, but the print is too small to read."
                                next
                            end
                            
                            @game.screen "What would you like to do next?"
                            while true
                                case @game.show_menu ["1. Take the treasure","2. Leave the room"]
                                when "1" 
                                    @game.screen "You have taken the treasure and won the game!"
                                    return "Exit_Game"
                                when "2"
                                    @game.move_south
                                    return @game.next_location
                                end
                            end
                        else
                            @game.screen "This is a large and strong safe, but you do not know it's combination. Maybe if you had written it down..."
                        end
                    else
                        @game.screen "You cannot tell what this object is a because it is dark."
                    end

                when "3"
                    @game.move_south
                    return @game.next_location
                end
            end
        else
            @game.screen "You find that the door is tightly locked. You give up and go back to the path."
            @game.move_south
            return @game.next_location
        end
    end 

    # Bright outdoor path
    def location_0_1_0
        @game.set_location(0,1,0)

        if @game.get_location_attribute("Berries") > 0
            @game.screen "You are outside on a bright sunny day. There is a path going south and a tiny house to your north. There also is a bush filled with tasty berries."
            while true
                case @game.show_menu ["1. Go into the house", "2. Eat some berries", "S. Go south on the path"]
                when "1"
                    @game.move_north
                    return @game.next_location
            
                when "s"
                    @game.move_south
                    return @game.next_location

                when "2"
                    @game.set_location_attribute("Berries",@game.get_location_attribute("Berries") - 1) # remove berries
                    if @game.get_location_attribute("Berries") > 0
                        @game.screen "The berries are delicious and you gained 25% health!"
                        h=@game.get_player_attribute("Health")
                        h=h+25
                        h = 100 if h > 100
                        @game.set_player_attribute("Health",h)
                        @game.screen "Your health is now #{@game.get_player_attribute("Health")}%."
                    else
                        @game.screen "You have eaten all of the berries."
                        return @game.next_location
                    end
                end
            end
        else
            @game.screen "You are outside on a bright sunny day. There is a path going south and a tiny house to your north. There also is a bush with no berries on it."
            while true
                case @game.show_menu ["1. Go into the house", "S. Go south on the path"]
                when "1"
                    @game.move_north
                    return @game.next_location
            
                when "s"
                    @game.move_south
                    return @game.next_location
                end 
            end
        end
    end

    # Note on the path
    def location_0_2_0
        @game.set_location(0,2,0)

        if @game.check_inventory_item("Scrap of Paper")
            @game.screen "You are just walking leasurely down the path and admiring how clean it is! You also see paths leading north, east and south."
            while true
                case @game.show_menu ["N. Go north on the path","S. Go south on the path","E. Go east on the path"]
                when "n"
                    @game.move_north
                    return @game.next_location
                
                when "s"
                    @game.move_south
                    return @game.next_location
                
                when "e"
                    @game.move_east
                    return @game.next_location
                end
            end
        else
            @game.screen "As you are walking down the path, you find a small scrap of paper on the ground. You also see paths leading north, east and south."
            while true
                case @game.show_menu ["1. Pick up the paper","N. Go north on the path","S. Go south on the path","E. Go east on the path"]
                when "1"
                    @game.pickup_item("Scrap of Paper")
                    @game.screen "You have picked up the scrap of paper. The writing on it is too small to read, but you kept it anyways."
                    return @game.next_location
                
                when "n"
                    @game.move_north
                    return @game.next_location
                
                when "s"
                    @game.move_south
                    return @game.next_location
                
                when "e"
                    @game.move_east
                    return @game.next_location
                end
            end
        end
    end

     # You can see a great void
    def location_0_3_0
        @game.set_location(0,3,0)

        @game.screen "To your north, you see a well groomed path. To the south, a Great Blue Void. Near you is a small park bench with peeling paint."
        while true
            case @game.show_menu ["N. Go north on the path","S. Go south on the path", "1. Sit on the park bench"]
            when "n"
                @game.move_north
                return @game.next_location
            
            when "s"
                @game.move_south
                return @game.next_location

            when "1"
                if @game.check_inventory_item("Old Lighter")
                    @game.screen "You are now seated comfortably and enjoying the scenery."
                    while true
                        case @game.show_menu ["1. Get up from the bench"]
                        
                        when "quit"
                            save_game
                            return "Exit_Game"
                        
                        when "1"
                            return @game.next_location
                        end
                    end
                else
                    @game.screen "You are now seated comfortably. While you are sitting you see an old lighter on the ground."
                    while true
                        case @game.show_menu ["1. Get up from the bench","2. Pick up the lighter"]
                        
                        when "quit"
                            save_game
                            return "Exit_Game"
                        
                        when "1"
                            return @game.next_location

                        when "2"
                            @game.pickup_item("Old Lighter")
                            @game.screen "You have picked up an old crusty lighter. To your suprise it still works fine!"
                            return @game.next_location
                        end
                    end                    
                end
            end
        end       
    end

    # Fall off the map into the Great Blue Void
    def location_0_4_0
        @game.set_location(0,4,0)

        @game.set_player_attribute("Lives",@game.get_player_attribute("Lives") - 1)

        @game.screen "You have fallen off the map into the Great Blue Void and lost your life! You are now starting over and have #{@game.get_player_attribute("Lives")} lives left."
        
        return player_reset
    end

    # Reset the player
    def player_reset
        @game.set_location(0,0,0)
        @game.set_location_attribute("Light Switch","OFF")
        @game.set_location(0,1,0)
        @game.set_location_attribute("Berries",4)
        @game.set_location(0,2,0)
        @game.add_location_item("Scrap of Paper")
        @game.remove_inventory_item("Scrap of Paper")
        @game.set_location(1,2,0)
        @game.add_location_item("Piece of Glass")
        @game.remove_inventory_item("Piece of Glass")
        @game.set_location(2,2,0)
        @game.add_location_item("Small Dagger")
        @game.remove_inventory_item("Small Dagger")
        @game.set_location(0,3,0)
        @game.add_location_item("Old Lighter")
        @game.remove_inventory_item("Old Lighter")
        @game.set_location(3,2,1)
        @game.add_location_item("Rusty Key")
        @game.remove_inventory_item("Rusty Key")
        @game.set_location(0,1,0)

        @game.set_npc_attribute(0,"Health",100)
        @game.set_npc_attribute(0,"Max Hit", 30)

        @game.set_player_attribute("Health",100)
        @game.set_player_attribute("Max Hit",10)
        
        return "Exit_Game" if @game.get_player_attribute("Lives") < 0
        return @game.next_location
    end

    # First East Path
     def location_1_2_0
        @game.set_location(1,2,0)

        if @game.check_inventory_item("Piece of Glass")
            @game.screen "You are on a winding eastward path and in the distance you see a small hole in the ground."
            while true
                case @game.show_menu ["E. Go east on the path","W. Go west on the path"]
                when "e"
                    @game.move_east
                    return @game.next_location
                
                when "w"
                    @game.move_west
                    return @game.next_location
               
                end
            end
        else
            @game.screen "You are on a winding eastward path and in the distance you see a small hole in the ground. In the nearby brush you see a small piece of clear glass."
            while true
                case @game.show_menu ["E. Go east on the path","W. Go west on the path","1. Pick up the piece of glass" ]
                when "e"
                    @game.move_east
                    return @game.next_location
                
                when "w"
                    @game.move_west
                    return @game.next_location

                when "1"
                    @game.pickup_item("Piece of Glass")
                    @game.screen "You have picked up the small piece of glass. It looks like a lens of some sorts."
                    return @game.next_location
                end
            end
        end
    end

    # The cave entrance
    def location_2_2_0
        @game.set_location(2,2,0)

        if @game.check_inventory_item("Small Dagger")
            @game.screen "You are at the entrance to a small cave. It is very dark inside."
            while true
                case @game.show_menu ["W. Go west on the path","1. Enter the cave"]
                when "w"
                    @game.move_west
                    return @game.next_location

                when "1"
                    @game.set_location(3,2,0)
                    return @game.next_location
                end 
            end   
        else
            @game.screen "You are at the entrance to a small cave. It is very dark inside. On the ground you see a small dagger."
            while true
                case @game.show_menu ["W. Go west on the path","1. Enter the cave", "2. Pick up the dagger"]
                when "w"
                    @game.move_west
                    return @game.next_location

                when "1"
                    @game.set_location(3,2,0)
                    return @game.next_location

                when "2"
                    @game.screen "You have picked up the small dagger. It is a bit rusty but still seems strong."
                    @game.pickup_item("Small Dagger")
                    @game.set_player_attribute("Max Hit", 40)
                    return @game.next_location
                end
            end 
        end  
    end  

    # The cave
    def location_3_2_0
        @game.set_location(3,2,0)

        if @game.get_npc_attribute(0,"Health") > 0
            @game.screen "You have entered the cave. It is very dark inside. Perhaps some light would be good. There is a faint snoring sound."

            if @game.check_inventory_item("Old Lighter")
                while true
                    case @game.show_menu ["1. Leave the cave", "2. Flick the lighter"]
                    when "1"
                        @game.set_location(2,2,0)
                        return @game.next_location

                    when "2"
                        @game.set_location(3,2,1)
                        return @game.next_location
                    end
                end
            else
                while true
                    case @game.show_menu ["1. Leave the cave"]
                    when "1"
                        @game.set_location(2,2,0)
                        return @game.next_location
                    end
                end
            end  
        else
            @game.screen "You have entered the cave. It is very dark inside. Perhaps some light would be good."
            if @game.check_inventory_item("Old Lighter")
                while true
                    case @game.show_menu ["1. Leave the cave", "2. Flick the lighter"]
                    when "1"
                        @game.set_location(2,2,0)
                        return @game.next_location

                    when "2"
                        if @game.check_inventory_item("Rusty Key")
                            @game.screen "In the faint light of the lighter, you see a dead troll."
                            case @game.show_menu ["1. Leave the cave"]
                            when "1"
                                @game.set_location(2,2,0)
                                return @game.next_location
                            end
                        else
                            @game.screen "In the faint light of the lighter, you see a dead troll and a rusty old key."
                            case @game.show_menu ["1. Leave the cave", "2. Pick up the key"]
                            when "1"
                                @game.set_location(2,2,0)
                                return @game.next_location

                            when "2"
                                @game.pickup_item("Rusty Key")
                                @game.screen "You have picked up the key and decided to leave the cave."
                                @game.set_location(2,2,0)
                                return @game.next_location
                            end
                        end
                    end
                end
            else
                while true
                    case @game.show_menu ["1. Leave the cave"]
                    when "1"
                        @game.set_location(2,2,0)
                        return @game.next_location
                    end
                end
            end  
        end  
    end  

    # The troll
    def location_3_2_1
        @game.set_location(3,2,1)

        if @game.check_inventory_item("Small Dagger")
            dagger = true
        else
            dagger = false
        end

        if @game.get_npc_attribute(0,"Health") < 100
            @game.screen "In the faint flicker of the lighter you see that the troll is awake and staring at you!"
        else
            @game.screen "In the faint flicker of the lighter you see that it is a sleeping troll that is making the noise!"
        end 

        while true
            case @game.show_menu ["1. Leave the cave", "2. Poke the troll"]
            when "1"
                @game.set_location(2,2,0)
                return @game.next_location

            when "2"
                @game.screen "You have poked the troll and now he is awake and very angry!!!"

                troll_message = Array.new
                your_message = Array.new

                while true
                    troll_hit = rand(@game.get_npc_attribute(0,"Max Hit"))
                    troll_message[0] = "The troll jumps and hits you with #{troll_hit}% health damage."
                    troll_message[1] = "The troll swings and hits you with #{troll_hit}% health damage."
                    troll_message[2] = "The troll bites you and does #{troll_hit}% health damage."
                    
                    @game.screen (troll_message[rand(3)])
                    
                    @game.set_player_attribute("Health",@game.get_player_attribute("Health") - troll_hit) #take away player health
                    
                    if @game.get_player_attribute("Health") <= 0 # you died
                        @game.set_player_attribute("Health",100)
                        @game.set_player_attribute("Lives",@game.get_player_attribute("Lives") - 1)
                        @game.screen "You have died! You have #{@game.get_player_attribute("Lives")} left." if @game.get_player_attribute("Lives") > 0
                        return player_reset
                    end

                    case @game.show_menu ["1. Leave the cave", "2. Strike the troll"]
                    when "1"
                        @game.set_location(2,2,0)
                        return @game.next_location

                    when "2"
                        your_hit = rand(@game.get_player_attribute("Max Hit"))

                        your_message[0] = "You swing with all your might and strike the troll with #{your_hit}% health damage."
                        your_message[1] = "You jump at the troll and deal #{your_hit}% health damage."
                        your_message[2] = "You circle around and hit the troll from behind for #{your_hit}% health damage."
                        
                        @game.screen (your_message[rand(3)])

                        @game.set_npc_attribute(0,"Health",@game.get_npc_attribute(0,"Health") - your_hit) #take away troll health

                        @game.screen "The troll still has #{@game.get_npc_attribute(0,"Health")}% health left." if @game.get_npc_attribute(0,"Health") > 0
                        @game.screen "You still have #{@game.get_player_attribute("Health")}% health left." if @game.get_player_attribute("Health") > 0
                        if no_dagger == false
                            @game.screen "Maybe if you had a weapon you could defend yourself better!" 
                            no_dagger = true
                        end

                        if @game.get_npc_attribute(0,"Health") <= 0
                            @game.screen "You have successfully killed the troll! You see that he dropped a small key."
                            case @game.show_menu ["1. Leave the cave", "2. Pick up the key"]
                            when "1"
                                @game.set_location(2,2,0)
                                return @game.next_location

                            when "2"
                                @game.pickup_item("Rusty Key")
                                @game.screen "You have picked up the key and decided to leave the cave."
                                @game.set_location(2,2,0)
                                return @game.next_location
                            end
                        end
                    end
                end
            end
        end
    end
end


#*****************
# MAIN GAME LOOP *
#*****************

# Create a set of locations
locations = Locations.new

# Start the game loop from the last starting point
next_location = locations.send("get_next_location")

# Main Game Loop, return Exit_Game to quit
while true
    next_location = locations.send(next_location)
    break if next_location == "Exit_Game"
end

# Exit the game
puts "You have left the game!"