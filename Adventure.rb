require 'colored'
require 'io/console'
# Notes all set functions return true on failure!
# Global variables may be edited at will



# Global Constants
MAX_INVENTORY = 10
MAX_NPC = 10
GRID_SIZE_X = 10
GRID_SIZE_Y = 10
GRID_SIZE_Z = 1

# Class to Keep track of the current location information
class Game
    
    # Initialize class
    def initialize()
        @x = 0
        @y = 0
        @z = 0
        @user_name = ""
        @npc = Array.new(MAX_NPC)
        @location_items = Array.new(GRID_SIZE_X) {Array.new(GRID_SIZE_Y) {Array.new(GRID_SIZE_Z)}}
        @location_attributes = Array.new(GRID_SIZE_X) {Array.new(GRID_SIZE_Y) {Array.new(GRID_SIZE_Z)}}
        @location_npcs = Array.new(GRID_SIZE_X) {Array.new(GRID_SIZE_Y) {Array.new(GRID_SIZE_Z)}}
        @player_attributes = Hash.new()
        @npc_attributes = Hash.new()
        @inventory = Hash.new()
        Random.new_seed
    end

    # Save player status to disk
    def save()
        begin
            File.open("#{@user_name}_game.save", "wb") do |file|
                file.puts @x
                file.puts @y
                file.puts @z
                file.puts @user_name
                file.puts Marshal.dump(@location_items)
                file.puts Marshal.dump(@location_attributes)
                file.puts Marshal.dump(@location_npcs)
                file.puts Marshal.dump(@npc)
            end
            File.open("#{@user_name}_player.save", "wb") do |file|
                Marshal.dump(@player_attributes,file)
            end
            File.open("#{@user_name}_npc.save", "wb") do |file|
                Marshal.dump(@npc_attributes,file)
            end
            File.open("#{@user_name}_inventory.save", "wb") do |file|
                Marshal.dump(@inventory,file)
            end
        rescue
            return true
        end
        return false
    end

    # Load player status from disk
    def load()
        return true if File.file?("#{@user_name}_game.save") == false
        return true if File.file?("#{@user_name}_player.save") == false
        return true if File.file?("#{@user_name}_npc.save") == false
        return true if File.file?("#{@user_name}_inventory.save") == false
        
        begin
            File.open("#{@user_name}_game.save", "rb") do |file|
                @x = file.gets.chomp.to_i
                @y = file.gets.chomp.to_i
                @z = file.gets.chomp.to_i
                @user_name = file.gets.chomp
                @location_items = Array.new(Marshal.load(file.gets.chomp))
                @location_attributes = Array.new(Marshal.load(file.gets.chomp))
                @location_npcs = Array.new(Marshal.load(file.gets.chomp))
                @npc = Array.new(Marshal.load(file.gets.chomp))
            end
            File.open("#{@user_name}_player.save", "rb") do |file|
                @player_attributes = Marshal.load(file)
            end
            File.open("#{@user_name}_npc.save", "rb") do |file|
                @npc_attributes = Marshal.load(file)
            end
            File.open("#{@user_name}_inventory.save", "rb") do |file|
                @inventory = Marshal.load(file)
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
            puts "\n" + str.white + "\n"
            return
        end
        while start_pos < str.length
            sp = str.rindex(' ', start_pos)
            str.insert(sp, '|')
            start_pos = sp + wrap_len + 1
        end
        puts "\n" + str.gsub!(/\|[\s]/, "\n").white
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
            puts "\n What would you like to do?  <h>elp  <i>ventory  <p>layer attributes  <q>uit game".cyan
            listing.each {|x| puts "    #{x}".green}

            input = STDIN.noecho(&:gets).chomp.downcase

            case input

            when "q"
                save
                # Exit the game
                puts "\nYour progress has been saved."
                puts "You have left the game!"
                exit

            when "p"
                puts "\n Your attributes:".red
                list_player_attributes.each do |x,y| puts "   #{x}: #{y}"
                end 
                next

            when "h"
                puts "The Help Screen".yellow
                next

            when "i"
                puts "\n Your inventory:".red
                list_inventory_items.each do |x,y| puts "   #{x}: #{y}"
                end
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

    # Add player inventory
    def add_inventory_item(item)
        @inventory = Hash.new if @inventory == nil
        return true if @inventory.keys.count >= MAX_INVENTORY
        @inventory[item] = @inventory[item] + 1 if check_inventory_item(item)
        @inventory[item] = 1
        return false
    end

    # List player inventory
    def list_inventory_items()
        return @inventory
    end

    # Check player inventory for an item
    def check_inventory_item(item)
        begin
            return true if @inventory.key?(item)
        rescue
            return false
        end
        return 
    end

    # Remove item from player inventory
    def remove_inventory_item(item)
        begin
            @inventory.delete(item)
            return false
        rescue
            return true
        end
    end

    # Get count of a player inventory item
    def check_inventory_item_count(item)
        begin
            return @inventory.fetch(item) if @inventory.key?(item)
        rescue
            return 0
        end
        return 0
    end

    # Set player attribute
    def set_player_attribute(item,value)
        @player_attributes = Hash.new if @player_attributes == nil
        @player_attributes.store(item,value)
        return false
    end

    # Get attribute for player
    def get_player_attribute(item)
        begin
            return @player_attributes.fetch(item)
        rescue
            return nil
        end
    end

    # List player attributes
    def list_player_attributes
        return @player_attributes
    end
    
    # Remove player attribute
    def remove_player_attribute(item)
        begin
            @player_attributes.delete(item)
            return false
        rescue
            return true
        end
    end

    # Set npc attribute
    def set_npc_attribute(number,item,value)
        return true if number > MAX_NPC 
        @npc[number] = Hash.new if @npc[number] == nil
        attributes = @npc[number]
        attributes.store(item,value)
        @npc[number] = attributes
        return false
    end

    # Get attribute for npc
    def get_npc_attribute(number,item)
        return nil if @npc[number] == nil
        begin
            attributes = @npc[number]
            return attributes.fetch(item)
        rescue
            return nil
        end
    end

    # Remove npc attribute
    def remove_npc_attribute(item)
        return true if @npc[number] == nil
        begin
            attributes = @npc[number]
            attributes.delete(item)
            @npc[number] = attributes
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

    # Add npc to a location
    def add_location_npc(number)
        @location_npcs[@x][@y][@z] = Array.new if @location_npcs[@x][@y][@z] == nil
        @location_npcs[@x][@y][@z].push(number)
        @location_npcs[@x][@y][@z] = @location_npcs[@x][@y][@z].uniq
    end

    # List npcs in a location
    def list_location_npcs()
        return @location_npcs[@x][@y][@z]
    end

    # Remove npc from location
    def remove_location_npc(number)
        begin
            @location_npcs[@x][@y][@z].delete(number)
            return false
        rescue
            return true
        end
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

    # Remove a location attribute
    def remove_location_attribute(item)
         begin
            @location_attributes[@x][@y][@z].delete(item)
            return false
        rescue
            return true
        end
    end

    # List attributes for a location
    def list_location_attributes()
        return @location_attributes[@x][@y][@z]
    end

    # Pick up item
    def pickup_item(item)
        remove_location_item(item)
        return add_inventory_item(item)
    end

    # Drop item
    def drop_item(item)
        remove_inventory_item(item)
        add_location_item(item)
    end

    # Set username
    def set_user_name(name)
        @user_name = name
    end

    # Get username
    def get_user_name
       return @user_name
    end
end
