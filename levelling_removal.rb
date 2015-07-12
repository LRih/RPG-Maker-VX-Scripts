#==============================================================================
# ** Levelling Removal by RPGI
#------------------------------------------------------------------------------
#  This script removes levelling and the display of levels from the game.
#==============================================================================

class Scene_Battle < Scene_Base
  def process_victory
    @info_viewport.visible = false
    @message_window.visible = true
    RPG::BGM.stop
    $game_system.battle_end_me.play
    unless $BTEST
      $game_temp.map_bgm.play
      $game_temp.map_bgs.play
    end
    display_gold
    display_drop_items
    battle_end(0)
  end
  def display_gold
    gold = $game_troop.gold_total
    $game_party.gain_gold(gold)
    text = sprintf(Vocab::Victory, $game_party.name)
    $game_message.texts.push('\|' + text)
    if gold > 0
      text = sprintf(Vocab::ObtainGold, gold, Vocab::gold)
      $game_message.texts.push('\.' + text)
    end
    wait_for_message
  end
end

class Window_Status < Window_Base
  def draw_exp_info(x, y)
  end
end

class Window_Base < Window
  def draw_actor_level(actor, x, y)
  end
end
