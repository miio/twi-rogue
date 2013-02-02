class UserGameReport < ActiveRecord::Base
  belongs_to :user_game
  attr_accessible :body, :user_game
end
