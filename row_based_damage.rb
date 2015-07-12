#==============================================================================
# ** Row Based Damage by RPGI
#------------------------------------------------------------------------------
#  This is a small script that allows damage modifiers based on character row.
#
#  How to use:
#    Row modifiers can be defined here:
module RowDmg
      FRONT_ROW_ATTACK_MOD = 100
      MID_ROW_ATTACK_MOD   = 75
      BACK_ROW_ATTACK_MOD  = 50
end
#
#    - All normal attacks will have their damage reduced accordingly by row
#      modifiers.
#    - All magic attacks will do normal damage.
#    - A ranged weapon (ignore row) can be defined by using the following note
#      tag in it's note box:
#        <ranged>
#    - An enemy can also have a row ignoring normal attack by placing the same
#      note tag in it's note box:
#        <ranged>
#        
#==============================================================================

class Game_Battler
  alias make_attack_damage_value_row make_attack_damage_value
  def make_attack_damage_value(attacker)
    make_attack_damage_value_row(attacker)
    if not attacker.ranged then
      if attacker.actor? then
        case attacker.class.position
        when 0; @hp_damage *= RowDmg::FRONT_ROW_ATTACK_MOD / 100.0 # front row
        when 1; @hp_damage *= RowDmg::MID_ROW_ATTACK_MOD / 100.0   # mid row
        when 2; @hp_damage *= RowDmg::BACK_ROW_ATTACK_MOD / 100.0  # back row
        end
        @hp_damage = Integer(@hp_damage)
      end
      if self.actor? then
        case self.class.position
        when 0; @hp_damage *= RowDmg::FRONT_ROW_ATTACK_MOD / 100.0 # front row
        when 1; @hp_damage *= RowDmg::MID_ROW_ATTACK_MOD / 100.0   # mid row
        when 2; @hp_damage *= RowDmg::BACK_ROW_ATTACK_MOD / 100.0  # back row
        end
        @hp_damage = Integer(@hp_damage)
      end
    end
  end
end

class Game_Actor < Game_Battler
  def ranged
    for weapon in weapons.compact do return true if weapon.ranged end
    return false
  end
end

class Game_Enemy < Game_Battler
    def ranged
    return (self.enemy.note[/<ranged>/] != nil)
  end
end

class RPG::Weapon
  def ranged
    return (self.note[/<ranged>/] != nil)
  end
end
