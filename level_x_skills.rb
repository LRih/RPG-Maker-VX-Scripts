#==============================================================================
# ** Skill Effect Dependent on Target Level
#      by RPGI
#------------------------------------------------------------------------------
#  This script allows the creation of skills that only hit targets of certain
#  levels such as the Level X spells seen so often in the Final Fantasy series.
#
#  How to use:
#    To create a skill that only hits targets with a level that is a multiple
#    of X, place in the skill's notebox:
#      <levelhit=X>
#
#    Since monsters do not have levels in the default system, you may define
#    monster levels in the enemy notebox like so:
#      <level=X>
#
#  Notes:
#    If a monster level is not defined, it defaults to 1.
#==============================================================================

class Game_Enemy < Game_Battler
  def level
    return (self.enemy.note[/<level=(\d+)>/] != nil ? $1.to_i : 1)
  end
end

class Game_Battler
  alias calc_hit_level calc_hit
  def calc_hit(user, obj = nil)
    if obj != nil then
      return 0 if self.level % obj.levelhit != 0
    end
    calc_hit_level(user, obj)
  end
end

class RPG::UsableItem
  def levelhit
    return (self.note[/<levelhit=(\d+)>/] != nil ? $1.to_i : 1)
  end
end
