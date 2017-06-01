require 'colored'
require 'io/console'
# Notes all set functions return true on failure!
# Global variables may be edited at will



# Global Constants
MAX_HEALTH = 100
MAX_LIVES = 3
MAX_INVENTORY = 10
GRID_SIZE_X = 10
GRID_SIZE_Y = 10
GRID_SIZE_Z = 1

# Class to Keep track of the current location information
class Player
    
    # Initialize class
    def initialize()
        @x = 0
        @y = 0
        @z = 0
        @health = MAX_HEALTH
        @lives = MAX_LIVES
        @score = 0
        @user_name = ""
        @inventory = Array.new()
        @player_attributes = Array.new()
        @location_items = Array.new(GRID_SIZE_X) {Array.new(GRID_SIZE_Y) {Array.new(GRID_SIZE_Z)}}
        @location_attributes = Array.new(GRID_SIZE_X) {Array.new(GRID_SIZE_Y) {Array.new(GRID_SIZE_Z)}}
    end

    # Save player status to disk
    def save()
        begin
            File.open(@user_name, "w") do |file|
                file.puts @x
                file.puts @y
                file.puts @z
                file.puts @health
                file.puts @lives
                file.puts @score
                file.puts @user_name
                file.puts Marshal.dump(@inventory)
                file.puts Marshal.dump(@location_items)
                file.puts Marshal.dump(@location_attributes)
                file.puts Marshal.dump(@player_attributes)
            end
        rescue
            return true
        end
        return false
    end

    # Load player status from disk
    def load()
        begin
            File.open(@user_name, "r") do |file|
                @x = file.gets.chomp.to_i
                @y = file.gets.chomp.to_i
                @z = file.gets.chomp.to_i
                @health = file.gets.chomp.to_i
                @lives = file.gets.chomp.to_i
                @score = file.gets.chomp.to_i
                @user_name = file.gets.chomp
                @inventory = Array.new(Marshal.restore(file.gets.chomp))
                @location_items = Array.new(Marshal.restore(file.gets.chomp))
                @location_attributes = Array.new(Marshal.restore(file.gets.chomp))
                @player_attributes = Array.new(Marshal.restore(file.gets.chomp))
            end
        rescue
            return true
        end
        return false
    end

    # Send messages to the players screen nicely formatted
    def screen(str)
        wrap_len = 78
        start_pos = wrap_len
        if str.length <= start_pos
            puts "\n" + str.green + "\n"
            return
        end
        while start_pos < str.length
            sp = str.rindex(' ', start_pos)
            str.insert(sp, '|')
            start_pos = sp + wrap_len + 1
        end
        puts "\n" + str.gsub!(/\|[\s]/, "\n").green
    end

    # Toggle an item
    def toggle(str)
        return "ON" if str == "OFF"
        return "OFF" if str == "ON"
        return 0 if str == 1
        return 1 if str == 0
        return "NO" if str == "YES"
        return "YES" if str == "NO"
        return str 
    end 

    # Show menu - returns "quit" if player chooses 'q'
    def show_menu(listing)
        while true
            puts "\n What would you like to do?  <h>elp  <i>ventory  <p>layer status  <q>uit game".cyan
            listing.each {|x| puts "    #{x}"}

            input = STDIN.noecho(&:gets).chomp.downcase

            case input

            when "p"
                puts "\n Player status:".red
                puts "    Lives: ".red + "#{@lives}"
                puts "    Health: ".red + " #{@health}%"
                puts "    Score: ".red + "#{@score} points"
                puts "\n\n" 
                next

            when "q"
                return "quit"

            when "h"
                puts "The Help Screen".yellow
                next

            when "i"
                puts "\n Your inventory:".red
                list_inventory_items.each_with_index {|x,y| puts "    #{y+1}. #{x}"}
                puts "\n\n"
                next
            end
        puts "\n\n"
        return input
        end
    end

    # Convert the current location to a function name
    def next_location
        return "location_#{@x}_#{@y}_#{@z}"
    end 

    # Add health to player
    def add_health(health)
        if @health < MAX_HEALTH
            @health += health
            return false
        else
            return true
        end
    end

    # Remove health from player
    def remove_health(health)
        if @health > 0
            @health -= health
            return false
        else
            return true
        end
    end

    # Get health
    def get_health()
        return @health
    end

    # Set health
    def set_health(health)
        if health >= 0 and health <= MAX_HEALTH 
            @health = health
            return false
        else
            return true
        end
    end

    # Add lives to player
    def add_lives(lives)
        if @lives < MAX_LIVES
            @lives += lives
            return false
        else
            return true
        end
    end

    # Remove lives from player
    def remove_lives(lives)
        if @lives > 0
            @lives -= lives
            return false
        else
            return true
        end
    end

    # Get number of lives
    def get_lives()
        return @lives
    end

    # Set number of lives
    def set_lives(lives)
        if lives >= 0 and lives <= MAX_LIVES 
            @lives = lives
            return false
        else
            return true
        end
    end

    # Return current location
    def get_location()
        return @x,@y,@z 
    end

    # Set the location
    def set_location(x=0,y=0,z=0)
        return true if x<0 or x>GRID_SIZE_X 
        return true if y<0 or y>GRID_SIZE_Y
        return true if z<0 or z>GRID_SIZE_Z
        @x=x
        @y=y
        @z=z
        return false
    end

    # Move player North
    def move_north
        if @y > 0 
            @y -= 1
            return false
        else
            return true
        end
    end

    # Move player South
    def move_south
         if @y <  GRID_SIZE_Y
            @y += 1
            return false
        else
            return true
        end
    end

    # Move player East
    def move_east
        if @x <  GRID_SIZE_X
            @x += 1
            return false
        else
            return true
        end
    end

    # Move player West
    def move_west
         if @x > 0 
            @x -= 1
            return false
        else
            return true
        end
    end

    # Move player Up
    def move_up
        if @z <  GRID_SIZE_Z
            @z += 1
            return false
        else
            return true
        end
    end

    # Move player Down
    def move_down
         if @z > 0 
            @z -= 1
            return false
        else
            return true
        end
    end

    # Add inventory
    def add_inventory_item(item)
        @inventory = Array.new if @inventory == nil
        return true if @inventory.count >= MAX_INVENTORY 
        @inventory.push(item)
        @inventory = @inventory.uniq
        return false
    end

    # List inventory
    def list_inventory_items()
        return @inventory
    end

    # Check inventory for an item
    def check_inventory_item(item)
        begin
            return true if @inventory.include?(item)
        rescue
            return false
        end
        return 
    end

    # Remove item from inventory
    def remove_inventory_item(item)
        begin
            @inventory.delete(item)
            return false
        rescue
            return true
        end
    end

    # Add player attribute
    def add_player_attribute(item)
        @player_attributes = Array.new if @player_attributes == nil
        @player_attributes.push(item)
        @player_attributes = @player_attributes.uniq
        return false
    end

    # List player attributes
    def list_player_attributes()
        return @player_attributes
    end

    # Check player for attribute
    def check_player_attribute(item)
        begin
            return true if @player_attributes.include?(item)
        rescue
            return false
        end
        return 
    end

    # Remove player attributes
    def remove_player_attribute(item)
        begin
            @player_attributes.delete(item)
            return false
        rescue
            return true
        end
    end

    # Add item to a location
    def add_location_item(item)
        @location_items[@x][@y][@z] = Array.new if @location_items[@x][@y][@z] == nil
        @location_items[@x][@y][@z].push(item)
        @location_items[@x][@y][@z] = @location_items[@x][@y][@z].uniq
    end

    # List items in a location
    def list_location_items()
        return @location_items[@x][@y][@z]
    end

    # Remove item from location
    def remove_location_item(item)
        begin
            @location_items[@x][@y][@z].delete(item)
            return false
        rescue
            return true
        end
    end

    # Check location for an item
    def check_location_item(item)
        begin
            return true if @location_items[@x][@y][@z].include?(item)
        rescue
            return false
        end
        return 
    end

    # Add a location attribute
    def set_location_attribute(item,status)
        @location_attributes[@x][@y][@z] = Hash.new if @location_attributes[@x][@y][@z] == nil
        @location_attributes[@x][@y][@z][item] = status
    end

    # Get a location attribute
    def get_location_attribute(item)
        return @location_attributes[@x][@y][@z][item]
    end

    # List attributes for a location
    def list_location_attributes()
        return @location_attributes[@x][@y][@z]
    end

    # Pick Up Item
    def pickup_item(item)
        remove_location_item(item)
        return add_inventory_item(item)
    end

    # Drop Item
    def drop_item(item)
        remove_inventory_item(item)
        add_location_item(item)
    end

    # Set Username
    def set_user_name(name)
        @user_name = name
    end

    # Get Username
    def get_user_name()
        return @user_name
    end

    # Set Score
    def set_score(score)
        @score = score
    end

    # Get Score
    def get_score(score)
        return @score = score
    end

    # Add to score
    def add_score(score)
         @score += score
    end

    # Remove from score
    def remove_score(score)
        if @score > 0
            @score -= score
            return false
        else
            return true
        end
    end
end
