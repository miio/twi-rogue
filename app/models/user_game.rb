class UserGame < ActiveRecord::Base
  turntable :user_cluster, :user_id
  attr_accessible :status, :user_id, :dungeon_id
  after_create :after_dungeon_initialize
  def after_dungeon_initialize
    db = DungeonBattle.new self
    db.initialize_enemy
    db.initialize_player
  end
end
