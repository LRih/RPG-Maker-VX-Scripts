#==============================================================================
# ** Prevent States
#------------------------------------------------------------------------------
#  This script will prevent the application of states when a specified state
#  is active.
#  Note that this prevention takes precedence over the nonresistance option.
#
#  To use simply place the following code in the states note section such as:
#     <preventstate=X>
#       where X is the ID of the state you wish to prevent
#  Any state with the above note tag that is active will prevent state X from
#  being applied.
#
#  Multiple states may also be prevented by the same state like so:
#     <preventstate=X,Y,Z>
#==============================================================================

class Game_Battler
  def preventstate
    result = []
    for state in states.compact do
      for state_id in state.preventstate do result.push(state_id) end
    end
    return result
  end
  alias add_state_prevent add_state
  def add_state(state_id)
    return if preventstate.include?(state_id)
    add_state_prevent(state_id)
  end
end

class Game_Actor < Game_Battler
  alias state_probability_prevent state_probability
  def state_probability(state_id)
    return 0 if preventstate.include?(state_id)
    state_probability_prevent(state_id)
  end
end

class Game_Enemy < Game_Battler
  alias state_probability_prevent state_probability
  def state_probability(state_id)
    return 0 if preventstate.include?(state_id)
    state_probability_prevent(state_id)
  end
end

class RPG::State
  def preventstate
    if self.note[/<preventstate=(.+)>/] != nil then
      states = $1.split(",")
      result = []
      for state in states do result.push(state.to_i) end
      return result
    else
      return []
    end
  end
end
