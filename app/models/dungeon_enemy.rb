class DungeonEnemy < ActiveRecord::Base
  belongs_to :dungeon
  belongs_to :npc_enemy
  attr_accessible :id, :dungeon, :npc_enemy, :x, :y
  CACHE_PREFIX = "dungeon_dungeon_enemy_"
  def save_cache
    DungeonEnemy.save_cache_by_id self.dungeon_id
  end

  def self.save_cache_by_id dungeon_id
    Rails.cache.write("#{CACHE_PREFIX}#{dungeon_id}", DungeonEnemy.where(dungeon_id: dungeon_id).all(include: :npc_enemy))
  end

  def self.get_by_dungeon_id dungeon_id
    cache = Rails.cache.read("#{CACHE_PREFIX}#{dungeon_id}")
    return cache unless cache.nil?
    self.save_cache_by_id dungeon_id
    DungeonEnemy.where(dungeon_id: dungeon_id).all
  end

  def position= hash
    @x = hash[:x]
    @y = hash[:y]
  end

  def x
    @x
  end

  def y
    @y
  end
end
