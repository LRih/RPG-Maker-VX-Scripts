#==============================================================================
# ** Specialized Shops by RPGI
#------------------------------------------------------------------------------
#  This script allows specialized shops to be defined, meaning the types of
#  items that can be sold to such merchants is restricted to specified types.
#------------------------------------------------------------------------------
#  How to use (recommended for filtering few types only):
#    To restrict item types from a shop, use the "Script..." event right above
#    the shop event command without the quotation marks:
#      "shopfilter("type")"
#    Replace "type" above with one of the following:
#      "item", "weapon", "shield", "helmet", "armor", "accessory"
#    Example usage (will restrict selling of weapons and shields from the next
#    shop event):
#      shopfilter("weapon")
#      shopfilter("shield")
#------------------------------------------------------------------------------
#  How to use (recommended for filtering all but one type):
#    In most cases, it is desired that shops only deal with one type of item
#    so the following can also be used without quotation marks:
#      "shopfilter_all_except("type")"
#    This is used the same way as above except that all item types will be
#    restricted except the one specified in the function.
#------------------------------------------------------------------------------
#  Notes:
#    - After every shop event the filter is cleared so "Script..." must be
#      called before every shop that restricts item types.
#    - The specified type string is case sensitive so ensure it is entered
#      exactly.
#==============================================================================

class Game_Temp
  attr_accessor :filter_item_types
  alias s9shops_initialize initialize
  def initialize
    s9shops_initialize
    @filter_item_types = 0
  end
end

class Game_Interpreter
  def item_s_to_sshop(item_type_s)
    case item_type_s
    when "item"; return 1
    when "weapon"; return 2
    when "shield"; return 4
    when "helmet"; return 8
    when "armor"; return 16
    when "accessory"; return 32
    end
  end
  def shopfilter(item_type)
    $game_temp.filter_item_types += item_s_to_sshop(item_type)
  end
  def shopfilter_all_except(item_type)
    $game_temp.filter_item_types = 63
    $game_temp.filter_item_types -= item_s_to_sshop(item_type)
  end
end

class Scene_Shop < Scene_Base
  alias s9shops_terminate terminate
  def terminate
    s9shops_terminate
    $game_temp.filter_item_types = 0
  end
end

class Window_ShopSell < Window_Item
  def include?(item)
    return false if item == nil
    temp = $game_temp.filter_item_types
    if temp >= 32; temp -= 32
      return false if item.is_a?(RPG::Armor) and item.kind == 3
    end
    if temp >= 16; temp -= 16
      return false if item.is_a?(RPG::Armor) and item.kind == 2
    end
    if temp >= 8; temp -= 8
      return false if item.is_a?(RPG::Armor) and item.kind == 1
    end
    if temp >= 4; temp -= 4
      return false if item.is_a?(RPG::Armor) and item.kind == 0
    end
    if temp >= 2; temp -= 2
      return false if item.is_a?(RPG::Weapon)
    end
    if temp >= 1; temp -= 1
      return false if item.is_a?(RPG::UsableItem)
    end
    return true
  end
end
