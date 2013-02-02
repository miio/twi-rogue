class UserInfo < ActiveRecord::Base
  self.primary_key = :user_id
  devise :trackable, :omniauthable
  turntable :user_cluster, :user_id
  attr_accessible :user_id, :screen_name, :bio, :image_url, :web_url

  def status
    UserStatus.find(self)
  end

  def money
    UserMoney.find(self)
  end
end
