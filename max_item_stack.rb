#==============================================================================
# ** Max Number of Items Changer by RPGI
#------------------------------------------------------------------------------
#  This script allows the adjustment of the the maximum number of items held.
#
module VIPHNO
# 
# Change this value to the max number of items desired
  MAX_NUMBER = 20
#==============================================================================
end

class Game_Party < Game_Unit
  def gain_item(item, n, include_equip = false)
    number = item_number(item)
    case item
    when RPG::Item
      @items[item.id] = [[number + n, 0].max, VIPHNO::MAX_NUMBER].min
    when RPG::Weapon
      @weapons[item.id] = [[number + n, 0].max, VIPHNO::MAX_NUMBER].min
    when RPG::Armor
      @armors[item.id] = [[number + n, 0].max, VIPHNO::MAX_NUMBER].min
    end
    n += number
    if include_equip and n < 0
      for actor in members
        while n < 0 and actor.equips.include?(item)
          actor.discard_equip(item)
          n += 1
        end
      end
    end
  end
end

class Scene_Shop < Scene_Base
  def update_buy_selection
    @status_window.item = @buy_window.item
    if Input.trigger?(Input::B)
      Sound.play_cancel
      @command_window.active = true
      @dummy_window.visible = true
      @buy_window.active = false
      @buy_window.visible = false
      @status_window.visible = false
      @status_window.item = nil
      @help_window.set_text("")
      return
    end
    if Input.trigger?(Input::C)
      @item = @buy_window.item
      number = $game_party.item_number(@item)
      if @item == nil or @item.price > $game_party.gold or number == VIPHNO::MAX_NUMBER
        Sound.play_buzzer
      else
        Sound.play_decision
        max = @item.price == 0 ? VIPHNO::MAX_NUMBER : $game_party.gold / @item.price
        max = [max, VIPHNO::MAX_NUMBER - number].min
        @buy_window.active = false
        @buy_window.visible = false
        @number_window.set(@item, max, @item.price)
        @number_window.active = true
        @number_window.visible = true
      end
    end
  end
end

class Window_ShopBuy < Window_Selectable
  def draw_item(index)
    item = @data[index]
    number = $game_party.item_number(item)
    enabled = (item.price <= $game_party.gold and number < VIPHNO::MAX_NUMBER)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    draw_item_name(item, rect.x, rect.y, enabled)
    rect.width -= 4
    self.contents.draw_text(rect, item.price, 2)
  end
end
