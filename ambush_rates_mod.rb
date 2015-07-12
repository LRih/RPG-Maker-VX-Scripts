#==============================================================================
# ** Preemptive/Surprise Chance Modifying Skills by RPGI
#------------------------------------------------------------------------------
#  This small script allows skills to passively modify preemptive/surprise
#  probabilities and armor doing the same when equipped.
#
#  How to use:
#    The following go in the notes section of the skills that modify
#    percentages:
#    <modpreemptive=X>       Add/Sub the preemptive percentage by WHOLE numbers
#                            only.
#    <modpreemptive%=X>      Modify the preemptive percentage with a multipler.
#                            eg. To increase by 5%, use <modpreemptive%=5>
#    <modsurprise=X>         Surprise counterpart of add/sub modifier.
#    <modsurprise%=X>        Surprise counterpart of multipler modifier.
#
#  Also included is a debug function you can run from the Script Event Command:
#    show_current_preemptive
#  This will show you the current preemptive/surprise probabilities based on
#  the modifiers.
#
#  Notes:
#    - Addition and subtraction modifiers are performed before multipliers.
#    - The final probability will always be an integer.
#    - Multiple multiplying modifiers will NOT multiply into each other. eg.
#      If you have something that provides 150% and another 150%, it will not
#      be 1.50 * 1.50 = 225%. It will actually be 200%.
#
module PSMS_RPGI
#====CUSTOMISATION=============================================================
# The default preemptive/surprise probabilities when party AGI > troop AGI
  DEFAULT_UPPER_PREEMPTIVE = 5
  DEFAULT_UPPER_SURPRISE = 3
# The default preemptive/surprise probabilities when troop AGI > party AGI
  DEFAULT_LOWER_PREEMPTIVE = 3
  DEFAULT_LOWER_SURPRISE = 5
#==============================================================================
end

class Scene_Map < Scene_Base
  def preemptive_or_surprise
    actors_agi = $game_party.average_agi
    enemies_agi = $game_troop.average_agi
    if actors_agi >= enemies_agi
      percent_preemptive = PSMS_RPGI::DEFAULT_UPPER_PREEMPTIVE
      percent_surprise = PSMS_RPGI::DEFAULT_UPPER_SURPRISE
    else
      percent_preemptive = PSMS_RPGI::DEFAULT_LOWER_PREEMPTIVE
      percent_surprise = PSMS_RPGI::DEFAULT_LOWER_SURPRISE
    end
    percent_preemptive += $game_party.mod_preemptive
    percent_preemptive *= $game_party.mod_preemptive_per / 100.0
    percent_surprise += $game_party.mod_surprise
    percent_surprise *= $game_party.mod_surprise_per / 100.0
    percent_preemptive = [[Integer(percent_preemptive), 0].max, 100].min
    percent_surprise = [[Integer(percent_surprise), 0].max, 100].min
    if rand(100) < percent_preemptive
      $game_troop.preemptive = true
    elsif rand(100) < percent_surprise
      $game_troop.surprise = true
    end
  end
end

class Game_Party < Game_Unit
  def mod_preemptive
    result = 0
    for actor in members
      for skill in actor.skills do result += skill.mod_preemptive end
      for armor in actor.armors.compact do result += armor.mod_preemptive end
    end
    return result
  end
  def mod_preemptive_per
    result = 0
    for actor in members
      for skill in actor.skills do result += skill.mod_preemptive_per end
      for armor in actor.armors.compact do result += armor.mod_preemptive_per end
    end
    return result + 100
  end
    def mod_surprise
    result = 0
    for actor in members
      for skill in actor.skills do result += skill.mod_surprise end
      for armor in actor.armors.compact do result += armor.mod_surprise end
    end
    return result
  end
  def mod_surprise_per
    result = 0
    for actor in members
      for skill in actor.skills do result += skill.mod_surprise_per end
      for armor in actor.armors.compact do result += armor.mod_surprise_per end
    end
    return result + 100
  end
end

class Game_Interpreter
  def show_current_preemptive
    preemptive = PSMS_RPGI::DEFAULT_UPPER_PREEMPTIVE
    surprise = PSMS_RPGI::DEFAULT_UPPER_SURPRISE
    preemptive += $game_party.mod_preemptive
    preemptive *= $game_party.mod_preemptive_per / 100.0
    surprise += $game_party.mod_surprise
    surprise *= $game_party.mod_surprise_per / 100.0
    preemptive = [[Integer(preemptive), 0].max, 100].min
    surprise = [[Integer(surprise), 0].max, 100].min
    $game_message.texts.push("Party AGI > Troop AGI:")
    $game_message.texts.push("  Preemptive: " + preemptive.to_s + "% / " + "Surprise: " + surprise.to_s + "%")
    preemptive = PSMS_RPGI::DEFAULT_LOWER_PREEMPTIVE
    surprise = PSMS_RPGI::DEFAULT_LOWER_SURPRISE
    preemptive += $game_party.mod_preemptive
    preemptive *= $game_party.mod_preemptive_per / 100.0
    surprise += $game_party.mod_surprise
    surprise *= $game_party.mod_surprise_per / 100.0
    preemptive = [[Integer(preemptive), 0].max, 100].min
    surprise = [[Integer(surprise), 0].max, 100].min
    $game_message.texts.push("Troop AGI > Party AGI:")
    $game_message.texts.push("  Preemptive: " + preemptive.to_s + "% / " + "Surprise: " + surprise.to_s + "%")
  end
end

class RPG::BaseItem
  def mod_preemptive
    return (self.note[/<modpreemptive=(-*\d+)>/] != nil ? $1.to_i : 0)
  end
  def mod_surprise
    return (self.note[/<modsurprise=(-*\d+)>/] != nil ? $1.to_i : 0)
  end
  def mod_preemptive_per
    return (self.note[/<modpreemptive%=(-*\d+)>/] != nil ? $1.to_i : 0)
  end
  def mod_surprise_per
    return (self.note[/<modsurprise%=(-*\d+)>/] != nil ? $1.to_i : 0)
  end
end
