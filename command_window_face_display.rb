#==============================================================================
# ** Actor Command Face Display by RPGI
#------------------------------------------------------------------------------
#  This simple script adds actor face graphics to the actor command window in
#  battle.
#==============================================================================

class Window_ActorCommand < Window_Command
  alias setup_acf setup
  def setup(actor)
    @actor = actor
    setup_acf(actor)
  end
  def refresh
    return unless @actor != nil
    self.contents.clear
    draw_face(@actor.face_name, @actor.face_index, 0, 0)
    for i in 0...@item_max
      draw_item(i)
    end
  end
  def draw_item(index, enabled = true)
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(rect, @commands[index])
  end
  def draw_face(face_name, face_index, x, y, size = 96)
    bitmap = Cache.face(face_name)
    rect = Rect.new(0, 0, 0, 0)
    rect.x = face_index % 4 * 96 + (96 - size) / 2
    rect.y = face_index / 4 * 96 + (96 - size) / 2
    rect.width = size
    rect.height = size
    self.contents.blt(x, y, bitmap, rect, 128)
    bitmap.dispose
  end
end
