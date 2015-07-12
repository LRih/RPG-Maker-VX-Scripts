#==============================================================================
# ** Variable Display Box by RPGI
#------------------------------------------------------------------------------
#  This script creates a box on the map that displays a single variable. The
#  visibility of the box is controlled by a specified switch.
module DispVar
#------------------------------------------------------------------------------
# ** Config
#------------------------------------------------------------------------------
#  This is the message that is shown in the display window. "%s" represents the
#  variable.
   MESSAGE = "Dodges: %s"
#  Width of the display window.
   WIDTH = 160
#  The position of the window.
#    1 = Top left
#    2 = Top right
#    3 = Bottom left
#    4 = Bottom right
   POSITION = 3
#  The ID of the switch that controls the displaying of the display window.
   SWITCH_TRIGGER_ID = 1
#  The variable shown in the window.
   VAR_DISPLAY_ID = 1
#==============================================================================
end

class Scene_Map < Scene_Base
  alias start_disv start unless $@
  def start
    start_disv
    case DispVar::POSITION
    when 2; @var_window = Window_VarDisp.new(Graphics.width - DispVar::WIDTH, 0, DispVar::WIDTH, 56)
    when 3; @var_window = Window_VarDisp.new(0, Graphics.height - 56, DispVar::WIDTH, 56)
    when 4; @var_window = Window_VarDisp.new(Graphics.width - DispVar::WIDTH, Graphics.height - 56, DispVar::WIDTH, 56)
    else; @var_window = Window_VarDisp.new(0, 0, DispVar::WIDTH, 56)
    end
 end
 alias terminate_disv terminate unless $@
  def terminate
    @var_window.dispose
    terminate_disv
  end
  alias update_basic_disv update_basic unless $@
  def update_basic
    update_basic_disv
    @var_window.update
  end
  alias update_disv update unless $@
  def update
    update_disv
    @var_window.update
  end
end

class Window_VarDisp < Window_Base
  def initialize(x, y, width, height)
    super(x, y, width, height)
    self.visible = $game_switches[DispVar::SWITCH_TRIGGER_ID]
    @current_var = ""
    refresh
  end
  def update
    super
    self.visible = $game_switches[DispVar::SWITCH_TRIGGER_ID]
    refresh
  end
  def refresh
    return if @current_var == $game_variables[DispVar::VAR_DISPLAY_ID]
    @current_var = $game_variables[DispVar::VAR_DISPLAY_ID]
    self.contents.clear
    text = sprintf(DispVar::MESSAGE, $game_variables[DispVar::VAR_DISPLAY_ID])
    self.contents.draw_text(0, 0, DispVar::WIDTH - 32, 24, text, 1)
  end
end
