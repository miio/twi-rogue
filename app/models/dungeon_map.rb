class DungeonMap < ActiveRecord::Base
  belongs_to :dungeon
  attr_accessible :dungeon_id, :x, :y, :type#:provider, :uid, :access_token, :access_secret
  CACHE_PREFIX = "dungeon_"
  MAP_TYPE_NONE = 0
  MAP_TYPE_WALL = 1
  MAP_TYPE_ENEMY = 3
  MAP_TYPE_PLAYER = 4
  self.inheritance_column = :sub_type_class
end
