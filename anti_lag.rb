#==============================================================================
# ** Anti-Lag
#------------------------------------------------------------------------------
#==============================================================================

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class deals with events. It handles functions including event page 
# switching via condition determinants, and running parallel process events.
# It's used within the Game_Map class.
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Determine if Event is On Screen
  #--------------------------------------------------------------------------
  def on_screen
    return false unless ($game_player.x - @event.x).abs <= 9
    return false unless ($game_player.y - @event.y).abs <= 7
    return true
  end
end

#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Create Character Sprite
  #--------------------------------------------------------------------------
  def create_characters
    @character_sprites = {}
    for i in $game_map.events.keys.sort
      if $game_map.events[i].on_screen
        sprite = Sprite_Character.new(@viewport1, $game_map.events[i])
        @character_sprites[i] = sprite
      else
        @character_sprites[i] = nil
      end
    end
    vehicle_id = 1001
    for vehicle in $game_map.vehicles
      sprite = Sprite_Character.new(@viewport1, vehicle)
      @character_sprites[vehicle_id] = sprite
      vehicle_id += 1
    end
    @character_sprites[9001] = Sprite_Character.new(@viewport1, $game_player)
  end
  #--------------------------------------------------------------------------
  # * Dispose of Character Sprite
  #--------------------------------------------------------------------------
  def dispose_characters
    for i in @character_sprites.keys
      if @character_sprites[i] != nil
        @character_sprites[i].dispose
        @character_sprites[i] = nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Character Sprite
  #--------------------------------------------------------------------------
  def update_characters
    for i in @character_sprites.keys
      if i > 1000 then
        @character_sprites[i].update
        next
      end
      if @character_sprites[i] != nil and $game_map.events[i].on_screen
        @character_sprites[i].update
      elsif @character_sprites[i] != nil and not $game_map.events[i].on_screen
        @character_sprites[i].dispose
        @character_sprites[i] = nil
      elsif @character_sprites[i] == nil and $game_map.events[i].on_screen
        sprite = Sprite_Character.new(@viewport1, $game_map.events[i])
        @character_sprites[i] = sprite
      end
    end
  end
end
