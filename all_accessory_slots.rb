#==============================================================================
# ** All Accessory Slots by RPGI
#------------------------------------------------------------------------------
#  This script changes all equip slots into accessory.
#==============================================================================

class Window_Equip < Window_Selectable
  def refresh
    self.contents.clear
    @data = []
    for item in @actor.equips do @data.push(item) end
    @item_max = @data.size
    self.contents.font.color = system_color
    self.contents.draw_text(4, WLH * 0, 92, WLH, Vocab::armor4)
    self.contents.draw_text(4, WLH * 1, 92, WLH, Vocab::armor4)
    self.contents.draw_text(4, WLH * 2, 92, WLH, Vocab::armor4)
    self.contents.draw_text(4, WLH * 3, 92, WLH, Vocab::armor4)
    self.contents.draw_text(4, WLH * 4, 92, WLH, Vocab::armor4)
    draw_item_name(@data[0], 92, WLH * 0)
    draw_item_name(@data[1], 92, WLH * 1)
    draw_item_name(@data[2], 92, WLH * 2)
    draw_item_name(@data[3], 92, WLH * 3)
    draw_item_name(@data[4], 92, WLH * 4)
  end
end

class Window_EquipItem < Window_Item
  def initialize(x, y, width, height, actor, equip_type)
    @actor = actor
    @equip_type = 4
    super(x, y, width, height)
  end
end

class Game_Actor < Game_Battler
  def weapons
    result = []
    result.push($data_armors[@weapon_id])
    return result
  end
  def armors
    result = []
    result.push($data_armors[@armor1_id])
    result.push($data_armors[@armor2_id])
    result.push($data_armors[@armor3_id])
    result.push($data_armors[@armor4_id])
    return result
  end
  def change_equip(equip_type, item, test = false)
    last_item = equips[equip_type]
    unless test
      return if $game_party.item_number(item) == 0 if item != nil
      $game_party.gain_item(last_item, 1)
      $game_party.lose_item(item, 1)
    end
    item_id = item == nil ? 0 : item.id
    case equip_type
    when 0  # Weapon
      @weapon_id = item_id
    when 1  # Shield
      @armor1_id = item_id
    when 2  # Head
      @armor2_id = item_id
    when 3  # Body
      @armor3_id = item_id
    when 4  # Accessory
      @armor4_id = item_id
    end
  end
  def discard_equip(item)
    if item.is_a?(RPG::Weapon)
      if @weapon_id == item.id
        @weapon_id = 0
      elsif @armor1_id == item.id
        @armor1_id = 0
      end
    elsif item.is_a?(RPG::Armor)
      if @armor1_id == item.id
        @armor1_id = 0
      elsif @armor2_id == item.id
        @armor2_id = 0
      elsif @armor3_id == item.id
        @armor3_id = 0
      elsif @armor4_id == item.id
        @armor4_id = 0
      end
    end
  end
  def hit
    return 95
  end
  def cri
    return 4
  end
  def fast_attack
    return false
  end
  def dual_attack
    return false
  end
  def two_hands_legal?
    return true
  end
  def atk_animation_id
    return 1
  end
  def atk_animation_id2
    return 0
  end
end
