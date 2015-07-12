#==============================================================================
# ** Artifical Date Display by RPGI
#------------------------------------------------------------------------------
#  This script allows the displaying of in-game defined dates in a text
#  message box by accessing the defined variables using text message commands.
#
#  How to use:
#    Assign a variable ID to each of the variables below.
#    Define a starting date below.
#    Now everytime you access the specified variables with the text message
#    command '\V[ID]', it will show the respective date data.
#  To increment days:
#    All you have to do is modify the variable defined by
#    VARIABLE_ID_DAY_HOLDER using the standard 'Control Variables'
#    eg. if you want to increment 20 days, just add 20 days to the variable.
#  To define starting date:
#    See below 'Starting Date'
#
module GameTime
#------------------------------------------------------------------------------
# ** Date Variable IDs (all can be displayed using \V[ID])
#------------------------------------------------------------------------------
  VARIABLE_ID_DAY_HOLDER   = 1  # This variable holds the current day
  Variable_Weekday_String  = 2  # holds day of the week 
  Variable_Day_Integer     = 3  # holds day of the month 
  Variable_Day_String      = 4  # holds day of the month, adds 'st', 'nd' etc. 
  Variable_Month_Integer   = 5  # holds month as a number
  Variable_Month_String    = 6  # holds month as text
  Variable_Year            = 7  # holds the year
#------------------------------------------------------------------------------
# ** Starting Date Definition (defaultly set at 16 / June / 1990)
#------------------------------------------------------------------------------
  STARTING_DATE          = 16    # day of the month
  STARTING_MONTH         = 6     # month
  STARTING_YEAR          = 1990  # year
#==============================================================================
  def self.date_to_day(d, m, y)
    m = (m + 9) % 12
    y = y - m / 10
    return 365 * y + y / 4 - y / 100 + y / 400 + (m * 306 + 5)/10 + d - 1
  end
  def self.year
    g = $game_variables[VARIABLE_ID_DAY_HOLDER]
    y = (10000 * g + 14780) / 3652425
    ddd = g - (365 * y + y / 4 - y / 100 + y / 400)
    if (ddd < 0) then
      y = y - 1
      ddd = g - (365 * y + y / 4 - y / 100 + y / 400)
    end
    mi = (100 * ddd + 52) / 3060
    mm = (mi + 2) % 12 + 1
    y = y + (mi + 2) / 12
    dd = ddd - (mi * 306 + 5) / 10 + 1
    return y
  end
  def self.month
    g = $game_variables[VARIABLE_ID_DAY_HOLDER]
    y = (10000 * g + 14780) / 3652425
    ddd = g - (365 * y + y / 4 - y / 100 + y / 400)
    if (ddd < 0) then
      y = y - 1
      ddd = g - (365 * y + y / 4 - y / 100 + y / 400)
    end
    mi = (100 * ddd + 52) / 3060
    mm = (mi + 2) % 12 + 1
    y = y + (mi + 2) / 12
    dd = ddd - (mi * 306 + 5) / 10 + 1
    return mm
  end
  def self.day
    g = $game_variables[VARIABLE_ID_DAY_HOLDER]
    y = (10000 * g + 14780) / 3652425
    ddd = g - (365 * y + y / 4 - y / 100 + y / 400)
    if (ddd < 0) then
      y = y - 1
      ddd = g - (365 * y + y / 4 - y / 100 + y / 400)
    end
    mi = (100 * ddd + 52) / 3060
    mm = (mi + 2) % 12 + 1
    y = y + (mi + 2) / 12
    dd = ddd - (mi * 306 + 5) / 10 + 1
    return dd
  end
  def self.day_of_week
    case ($game_variables[GameTime::VARIABLE_ID_DAY_HOLDER] + 3) % 7
    when 0; return "Sunday"
    when 1; return "Monday"
    when 2; return "Tuesday"
    when 3; return "Wednesday"
    when 4; return "Thursday"
    when 5; return "Friday"
    when 6; return "Saturday"
    else; return "Unknown"
    end
  end
  def self.month_string
    case self.month
    when 1; return "January"
    when 2; return "February"
    when 3; return "March"
    when 4; return "April"
    when 5; return "May"
    when 6; return "June"
    when 7; return "July"
    when 8; return "August"
    when 9; return "September"
    when 10; return "October"
    when 11; return "November"
    when 12; return "December"
    else; return "Unknown"
    end
  end
end

class Game_Variables
  def [](variable_id)
    case variable_id
    when GameTime::Variable_Weekday_String; return GameTime.day_of_week
    when GameTime::Variable_Day_Integer; return GameTime.day
    when GameTime::Variable_Day_String
      case GameTime.day
      when 1; return "#{GameTime.day}st"
      when 2; return "#{GameTime.day}nd"
      when 3; return "#{GameTime.day}rd"
      else; return "#{GameTime.day}th"
      end
    when GameTime::Variable_Month_Integer; return GameTime.month
    when GameTime::Variable_Month_String; return GameTime.month_string
    when GameTime::Variable_Year; return GameTime.year
    else
      if @data[variable_id] == nil
        return 0
      else
        return @data[variable_id]
      end
    end
  end
end

class Scene_Title < Scene_Base
  alias create_game_objects_mod create_game_objects
  def create_game_objects
    create_game_objects_mod
    $game_variables[GameTime::VARIABLE_ID_DAY_HOLDER] = GameTime.date_to_day(GameTime::STARTING_DATE,
                                                                             GameTime::STARTING_MONTH,
                                                                             GameTime::STARTING_YEAR)
  end
end
