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
            @game.add_location_item("Treasure from Safe")
            @game.set_location(0,2,0)
            @game.add_location_item("Scrap of Paper")
            @game.set_location(1,2,0)
            @game.add_location_item("Piece of Glass")
            @game.set_location(0,0,0)
            @game.set_player_attribute("Lives",3)
            @game.set_npc_attribute(0,"Health",100)
            @game.set_npc_attribute(0,"Hit Points", -5)
            @game.set_npc_attribute(1,"Health",50)
            @game.set_npc_attribute(1,"Hit Points", -3)
            @game.add_location_npc(0)
            @game.add_location_npc(1)
            #@game.list_location_npcs().each do |i|
            #    puts @game.get_npc_attribute(i,"Health"),@game.get_npc_attribute(i,"Hit Points")
            #end
        else
            # Player loaded an existing game
            @game.screen "\nGame Loaded!\n\n"
        end
    end

    # Save the game
    def save_game
        if @game.save
            @game.screen "Unable to Save Game!"
        else
            @game.screen "Game Saved!"
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

        if @game.get_location_attribute("Light Switch") == "OFF"
            @game.screen "You are in a small dark room. You see a light switch on the wall. There is something large and metal on the floor."
            obj = "2. Inspect the large metal object"
        else
            @game.screen "You are in a small brightly lit room. You see a light switch on the wall. There is a large safe on the floor."
            obj = "2. Inspect the safe"
        end

        while true
            case @game.show_menu ["1. Flip light switch","#{obj}","3. Leave the room"]
            
            when "quit"
                save_game
                return "Exit_Game"
            
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
                            @game.screen "You are clever and used your small piece of glass like a magnifier to read the combination from the scrap of paper."
                        else
                            @game.screen "You have a small scrap of paper, but the print is too small to read."
                            next
                        end
                        
                        @game.screen "What would you like to do next?"
                        while true
                            case @game.show_menu ["1. Take the treasure","2. Leave the room"]
                            when "quit"
                                save_game
                                return "Exit_Game"
                            when "1" 
                                @game.screen "You have taken the treasure and won the game!"
                                return "Exit_Game"
                            when "2"
                                @game.move_south
                                return @game.next_location
                            end
                        end
                    else
                        @game.screen "This is a large and strong safe, but you do not know it's combination."
                    end
                else
                    @game.screen "You cannot tell what this object is a because it is dark."
                end

            when "3"
                @game.move_south
                return @game.next_location
            end
        end
    end 

    # Bright outdoor path
    def location_0_1_0
        @game.set_location(0,1,0)

        @game.screen "You are outside on a bright sunny day. There is a path going south and a tiny house to your north."
        while true
            case @game.show_menu ["1. Go into the house", "2. Go south on the path"]
            
            when "quit"
                save_game
                return "Exit_Game"
            
            when "1"
                @game.move_north
                return @game.next_location
           
             when "2"
                @game.move_south
                return @game.next_location
            end
        end
    end

    # Note on the path
    def location_0_2_0
        @game.set_location(0,2,0)

        if @game.check_inventory_item("Scrap of Paper")
            @game.screen "You are just walking leasurely down the path and admiring how clean it is! You also see paths leading north, east and south."
            while true
                case @game.show_menu ["1. Go north on the path","2. Go south on the path","3. Go east on the path"]
                
                when "quit"
                    save_game
                    return "Exit_Game"
                
                when "1"
                    @game.move_north
                    return @game.next_location
                
                when "2"
                    @game.move_south
                    return @game.next_location
                
                when "3"
                    @game.move_east
                    return @game.next_location
                end
            end
        else
            @game.screen "As you are walking down the path, you find a small scrap of paper on the ground. You also see paths leading north, east and south."
            while true
                case @game.show_menu ["1. Pick up the paper","2. Go north on the path","3. Go south on the path","4. Go east on the path"]
                
                when "quit"
                    save_game
                    return "Exit_Game"
                
                when "1"
                    @game.pickup_item("Scrap of Paper")
                    @game.screen "You have picked up the scrap of paper. The writing on it is too small to read, but you kept it anyways."
                    return @game.next_location
                
                when "2"
                    @game.move_north
                    return @game.next_location
                
                when "3"
                    @game.move_south
                    return @game.next_location
                
                when "4"
                    @game.move_east
                    return @game.next_location
                end
            end
        end
    end

     # You can see a great void
    def location_0_3_0
        @game.set_location(0,3,0)

        @game.screen "To your north, you see a well groomed path. To the south, a Great Blue Void."
        while true
            case @game.show_menu ["1. Go north on the path","2. Go south on the path"]
            
            when "quit"
                save_game
                return "Exit_Game"
            
            when "1"
                @game.move_north
                return @game.next_location
            
            when "2"
                @game.move_south
                return @game.next_location
            end
         end       
    end

    # Fall off the map into the Great Blue Void
    def location_0_4_0
        @game.set_location(0,4,0)

        @game.set_player_attribute("Lives",@game.get_player_attribute("Lives") - 1)

        @game.screen "You have fallen off the map into the Great Blue Void and lost your life! You are now starting over and have #{@game.get_player_attribute("Lives")} lives left."
        @game.set_location(0,0,0)
        @game.set_location_attribute("Light Switch","OFF")
        @game.add_location_item("Treasure from Safe")
        @game.set_location(0,2,0)
        @game.add_location_item("Scrap of Paper")
        @game.remove_inventory_item("Scrap of Paper")
        @game.set_location(1,2,0)
        @game.add_location_item("Piece of Glass")
        @game.remove_inventory_item("Piece of Glass")
        @game.set_location(0,0,0)
        
        return "Exit_Game" if @game.get_player_attribute("Lives") == 0

        return @game.next_location
    end

    # First East Path
     def location_1_2_0
        @game.set_location(1,2,0)

        if @game.check_inventory_item("Piece of Glass")
            @game.screen "You are on a winding eastward path, but you must turn around because the path is filled with brush."
            while true
                case @game.show_menu ["1. Go west on the path"]
                
                when "quit"
                    save_game
                    return "Exit_Game"
                
                when "1"
                    @game.move_west
                    return @game.next_location
                end
            end
        else
            @game.screen "You are on a winding eastward path, but you must turn around because the path is filled with brush. In the brush you small piece of clear glass."
            while true
                case @game.show_menu ["1. Go west on the path","2. Pick up the piece of glass"]
                
                when "quit"
                    save_game
                    return "Exit_Game"
                
                when "1"
                    @game.move_west
                    return @game.next_location

                when "2"
                    @game.pickup_item("Piece of Glass")
                    @game.screen "You have picked up the small piece of glass. It looks like a lens of some sorts."
                    return @game.next_location
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