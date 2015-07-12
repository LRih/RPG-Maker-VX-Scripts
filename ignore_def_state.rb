#==============================================================================
# ** Break State (Attacks Ignore Equipment Defense)
#      by RPGI
#------------------------------------------------------------------------------
#  This script adds a state that when inflicted, all attacks on the effected
#  target will ignore the additional DEF provided by equipment.
#
#  How to use:
#    To make a state with the break effect, add the following in the state's
#    notebox:
#      <break>
#==============================================================================

class Game_Actor < Game_Battler
  def base_def
    n = actor.parameters[3, @level]
    (for item in equips.compact do n += item.def end) unless has_break?
    return n
  end
  
  def has_break?
    for state in states do return true if state.break end
    return false
  end
end

class RPG::State
  def break
    return self.note[/<break>/] != nil
  end
end
