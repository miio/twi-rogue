class DungeonUser
  attr_accessor :user_id, :x, :y

  def initialize user_id, x, y
    self.user_id = user_id
    self.x = x
    self.y = y
  end
end
