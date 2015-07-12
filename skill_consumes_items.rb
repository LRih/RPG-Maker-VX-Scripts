#==============================================================================
# ** Skill Consume Items v0.3 by RPGI
#------------------------------------------------------------------------------
#  This scrip allows the creation of skills that require items to use and
#  consume the items when used.
#
#  How to use:
#    To define a skill that consumes an item(s), place in it's notebox:
#      <reqitem=ID1,N1|ID2,N2>     where  N = the number required
#                                        ID = the ID of the item required
#  Example usage:
#    <reqitem=1,2|2,4>  a skill with this would require 2 of item 1 and 4 of
#                       item 2
#
#==============================================================================

class Game_Actor < Game_Battler
  alias ri_skill_can_use? skill_can_use? unless $@
  def skill_can_use?(skill)
    return false unless have_skill_items?(skill)
    ri_skill_can_use?(skill)
  end
  def have_skill_items?(skill)
    datas = skill.requireitem
    return true if datas.empty?
    for data in datas do
      return false if $game_party.item_number($data_items[data[0]]) < data[1]
    end
    return true
  end
end

class Scene_Skill < Scene_Base
  alias ri_use_skill_nontarget use_skill_nontarget unless $@
  def use_skill_nontarget
    req_item_data = @skill.requireitem
    unless req_item_data.empty?
      for data in req_item_data do
        $game_party.gain_item($data_items[data[0]], -data[1])
      end
    end
    ri_use_skill_nontarget
  end
end

class Scene_Battle < Scene_Base
  alias ri_execute_action_skill execute_action_skill unless $@
  def execute_action_skill
    if @active_battler.actor? then
      req_item_data = @active_battler.action.skill.requireitem
      unless req_item_data.empty?
        for data in req_item_data do
          $game_party.gain_item($data_items[data[0]], -data[1])
        end
      end
    end
    ri_execute_action_skill
  end
end

class RPG::UsableItem
  def requireitem
    result = []
    if self.note[/<reqitem=(.+)>/] != nil then
      datas = $1.split("|")
      for data in datas do
        result.push(data.split(",").map { |data| data.to_i })
      end
    end
    return result
  end
end
