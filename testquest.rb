require './Adventure'

class Locations
#******************************
#******* Required stuff *******
#******************************

    # Intialization of the locations class at startup
    def initialize()
        @player = Player.new

        puts "Enter a Username to get started: "
        @player.set_user_name(gets.chomp.downcase)

        if @player.load
            # Set the initial game items and locations for a new game
            @player.screen "\nStarting New Game...\n\n"
            @player.screen "Welcome to the land of Test! You are on a short mission to demonstrate the Adventure game library. Please feel free to roam and watch out for voids!\n"
            @player.set_location(0,0,0)
            @player.set_location_attribute("Light Switch","OFF")
            @player.add_location_item("Treasure from Safe")
            @player.set_location(0,2,0)
            @player.add_location_item("Scrap of Paper")
            @player.set_location(1,2,0)
            @player.add_location_item("Piece of Glass")
            @player.set_location(0,0,0)
        else
            # Player loaded and existing game
            @player.screen "\nGame Loaded!\n\n"
        end
    end

    # Save the game
    def save_game
        if @player.save
            @player.screen "Unable to Save Game!"
        else
            @player.screen "Game Saved!"
        end
    end

    # Start where we left off
    def get_next_location
        return @player.next_location
    end

#****************************************************************************
#******* Grid Locations - Function Name Format: location_x_y_z ******
#****************************************************************************

    # Small dark room with a Safe
    def location_0_0_0
        @player.set_location(0,0,0)

        if @player.get_location_attribute("Light Switch") == "OFF"
            @player.screen "You are in a small dark room. You see a light switch on the wall. There is something large and metal on the floor."
            obj = "2. Inspect the large metal object"
        else
            @player.screen "You are in a small brightly lit room. You see a light switch on the wall. There is a large safe on the floor."
            obj = "2. Inspect the safe"
        end

        while true
            case @player.show_menu ["1. Flip light switch","#{obj}","3. Leave the room"]
            
            when "quit"
                save_game
                return "Exit_Game"
            
            when "1"
                @player.set_location_attribute("Light Switch", @player.toggle(@player.get_location_attribute("Light Switch")))
                if @player.get_location_attribute("Light Switch") == "ON" 
                    @player.screen "The light is on!"
                    return @player.next_location
                else
                    @player.screen "The light is off!"
                    return @player.next_location
                end

            when "2"
                if @player.get_location_attribute("Light Switch") == "ON"
                    if @player.check_inventory_item("Scrap of Paper")
                        if @player.check_inventory_item("Piece of Glass")
                            @player.screen "You are clever and used your small piece of glass like a magnifier to read the combination from the scrap of paper."
                        else
                            @player.screen "You have a small scrap of paper, but the print is too small to read."
                            next
                        end
                        
                        @player.screen "What would you like to do next?"
                        while true
                            case @player.show_menu ["1. Take the treasure","2. Leave the room"]
                            when "quit"
                                save_game
                                return "Exit_Game"
                            when "1" 
                                @player.screen "You have taken the treasure and won the game!"
                                return "Exit_Game"
                            when "2"
                                @player.move_south
                                return @player.next_location
                            end
                        end
                    else
                        @player.screen "This is a large and strong safe, but you do not know it's combination."
                    end
                else
                    @player.screen "You cannot tell what this object is a because it is dark."
                end

            when "3"
                @player.move_south
                return @player.next_location
            end
        end
    end 

    # Bright outdoor path
    def location_0_1_0
        @player.set_location(0,1,0)

        @player.screen "You are outside on a bright sunny day. There is a path going south and a tiny house to your north."
        while true
            case @player.show_menu ["1. Go into the house", "2. Go south on the path"]
            
            when "quit"
                save_game
                return "Exit_Game"
            
            when "1"
                @player.move_north
                return @player.next_location
           
             when "2"
                @player.move_south
                return @player.next_location
            end
        end
    end

    # Note on the path
    def location_0_2_0
        @player.set_location(0,2,0)

        if @player.check_inventory_item("Scrap of Paper")
            @player.screen "You are just walking leasurely down the path and admiring how clean it is! You also see a path leading east."
            while true
                case @player.show_menu ["1. Go north on the path","2. Go south on the path","3. Go east on the path", "4. Drop the scrap of paper"]
                
                when "quit"
                    save_game
                    return "Exit_Game"
                
                when "1"
                    @player.move_north
                    return @player.next_location
                
                when "2"
                    @player.move_south
                    return @player.next_location
                
                when "3"
                    @player.move_east
                    return @player.next_location
                
                when "4"
                    @player.screen "You have dropped the scrap of paper."
                    @player.drop_item("Scrap of Paper")
                    return @player.next_location
                end
            end
        else
            @player.screen "As you are walking down the path, you find a small scrap of paper on the ground. You also see a path leading east."
            while true
                case @player.show_menu ["1. Pick up the paper","2. Go north on the path","3. Go south on the path","4. Go east on the path"]
                
                when "quit"
                    save_game
                    return "Exit_Game"
                
                when "1"
                    @player.pickup_item("Scrap of Paper")
                    @player.screen "You have picked up the scrap of paper. The writing on it is too small to read, but you kept it anyways."
                    return @player.next_location
                
                when "2"
                    @player.move_north
                    return @player.next_location
                
                when "3"
                    @player.move_south
                    return @player.next_location
                
                when "4"
                    @player.move_east
                    return @player.next_location
                end
            end
        end
    end

     # You can see a great void
    def location_0_3_0
        @player.set_location(0,3,0)

        @player.screen "To your north, you see a well groomed path. To the south, a Great Blue Void."
        while true
            case @player.show_menu ["1. Go north on the path","2. Go south on the path"]
            
            when "quit"
                save_game
                return "Exit_Game"
            
            when "1"
                @player.move_north
                return @player.next_location
            
            when "2"
                @player.move_south
                return @player.next_location
            end
         end       
    end

    # Fall off the map into the Great Blue Void
    def location_0_4_0
        @player.set_location(0,4,0)

        @player.screen "You have fallen off the map into the Great Blue Void!"
        return "Exit_Game" if @player.remove_lives(1)

        @player.set_location(0,1,0)
        return @player.next_location
    end

    # First East Path
     def location_1_2_0
        @player.set_location(1,2,0)

        if @player.check_inventory_item("Piece of Glass")
            @player.screen "You are on a winding eastward path, but you must turn around because the path is filled with brush."
            while true
                case @player.show_menu ["1. Go west on the path"]
                
                when "quit"
                    save_game
                    return "Exit_Game"
                
                when "1"
                    @player.move_west
                    return @player.next_location
                end
            end
        else
            @player.screen "You are on a winding eastward path, but you must turn around because the path is filled with brush. In the brush you small piece of clear glass."
            while true
                case @player.show_menu ["1. Go west on the path","2. Pick up the piece of glass"]
                
                when "quit"
                    save_game
                    return "Exit_Game"
                
                when "1"
                    @player.move_west
                    return @player.next_location

                when "2"
                    @player.pickup_item("Piece of Glass")
                    @player.screen "You have picked up the small piece of glass. It looks like a lens of some sorts."
                    return @player.next_location
                end
            end
        end
    end   
end


#*************************************************
# MAIN GAME LOOP                                 *
#*************************************************

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