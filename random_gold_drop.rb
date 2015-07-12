#==============================================================================
# ** Random Gold Drop by RPGI
#------------------------------------------------------------------------------
#  This scripts allows you to specify an enemy gold drop range.
#
#  How to use:
#    To specify a gold drop range for a monster place in it's note tag:
#      <gold=min,max>
#    For example, if a monster is to drop between 8 ~ 20 gold the note tag
#    would be:
#      <gold=8,20>
#    If the range is not specified, the gold dropped will be taken as the
#    default value in the gold textbox.
#==============================================================================

class Game_Enemy < Game_Battler
  def gold_min
    if self.enemy.note[/<gold=(.+)>/] != nil then
      result = $1.split(",").map { |gold| gold.to_i }
      return result[0]
    else
      return enemy.gold
    end
  end
  def gold_max
    if self.enemy.note[/<gold=(.+)>/] != nil then
      result = $1.split(",").map { |gold| gold.to_i }
      return result[1]
    else
      return enemy.gold
    end
  end
end

class Game_Troop < Game_Unit
  def gold_total
    gold = 0
    for enemy in dead_members
      gold += rand(enemy.gold_max - enemy.gold_min + 1) + enemy.gold_min unless enemy.hidden
    end
    return gold
  end
end
