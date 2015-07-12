#==============================================================================
# ** Date Display by RPGI
#------------------------------------------------------------------------------
#  This script allows the displaying of dates in a text message box by
#  accessing the defined variables using text message commands.
#
#  How to use:
#    Assign a variable ID to each of the variables below (defaults 1-6).
#    Now everytime you access the specified variables with the text message
#    command '\V[ID]', it will show the respective date data.
#
#------------------------------------------------------------------------------
# ** Date Variables
#------------------------------------------------------------------------------
module ShowDate
  Variable_Weekday_String  = 1
  Variable_Day_Integer     = 2
  Variable_Day_String      = 3
  Variable_Month_Integer   = 4
  Variable_Month_String    = 5
  Variable_Year            = 6
end
#==============================================================================
class Game_Variables
  def [](variable_id)
    time = Time.new
    case variable_id
    when ShowDate::Variable_Weekday_String; return time.strftime("%A")
    when ShowDate::Variable_Day_Integer; return time.day
    when ShowDate::Variable_Day_String
      case time.day
      when 1; return "#{time.day}st"
      when 2; return "#{time.day}nd"
      when 3; return "#{time.day}rd"
      else; return "#{time.day}th"
      end
    when ShowDate::Variable_Month_Integer; return time.month
    when ShowDate::Variable_Month_String; return time.strftime("%B")
    when ShowDate::Variable_Year; return time.year
    else
      if @data[variable_id] == nil
        return 0
      else
        return @data[variable_id]
      end
    end
  end
end
