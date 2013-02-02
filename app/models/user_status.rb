class UserStatus < ActiveRecord::Base
  self.primary_key = :user_id
  turntable :user_cluster, :user_id
  belongs_to :user
  attr_accessible :user_id, :attack, :hp, :lv, :speed
  before_create :init

  FIRST_LV          = 1
  FIRST_ATTACK      = 15
  FIRST_HP          = 50
  FIRST_SPEED       = 5

  def init
    self.attack ||= FIRST_ATTACK
    self.hp     ||= FIRST_HP
    self.lv     ||= FIRST_LV
    self.speed  ||= FIRST_SPEED
  end
end
