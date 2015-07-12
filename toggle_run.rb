module ToggleRun_RPGI
#==============================================================================
# ** Toggle Run
#      Author : RPGI
#      Date   : 9 May 2010
#------------------------------------------------------------------------------
#  This script creates a dash that can be toggled on/off with the dash key
#  instead of constantly holding down the key to dash.
#
#  How to use:
#    Before running this script, set this value to the ID of the switch that
#    will control whether the script is on or off. Remember to turn on this
#    switch to activate the script.
     SCRIPT_ENABLED_SWITCH_ID = 1
#==============================================================================
end

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Aliased Method: initialize
  #--------------------------------------------------------------------------
  alias togglerun_initialize initialize unless $@
  def initialize
    togglerun_initialize
    @run_togged_on = false
  end
  #--------------------------------------------------------------------------
  # * Aliased Method: update
  #--------------------------------------------------------------------------
  alias togglerun_update update unless $@
  def update
    @run_togged_on = (@run_togged_on != true) if Input.trigger?(Input::A)
    togglerun_update
  end
  #--------------------------------------------------------------------------
  # * Overwritten Method: dash?
  #--------------------------------------------------------------------------
  def dash?
    return false if @move_route_forcing
    return false if $game_map.disable_dash?
    return false if in_vehicle?
    if $game_switches[ToggleRun_RPGI::SCRIPT_ENABLED_SWITCH_ID] then
      return @run_togged_on
    else
      return Input.press?(Input::A)
    end
  end
end

#==============================================================================
# ** END OF SCRIPT
#==============================================================================
