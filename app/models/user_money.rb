class UserMoney < ActiveRecord::Base
  self.primary_key = :user_id
  turntable :user_cluster, :user_id
  belongs_to :user
  attr_accessible :user_id, :money
  before_create :init

  FIRST_MONEY = 1000

  def init
    self.money ||= FIRST_MONEY
  end
end
