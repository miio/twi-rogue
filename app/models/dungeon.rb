class Dungeon < ActiveRecord::Base

  CACHE_PREFIX = "dungeon_"
  CACHE_XY_PREFIX = "xy_"
  CACHE_MAX = "max"
  ONE_LINE = 10

  def self.get_by_random
    size = Dungeon.get_count_with_cache
    if size > 1
      id = Random.new.rand 1..size
    else
      id = 1
    end
    id
  end

  def save_cache
    Dungeon.save_cache_by_id self.id
  end

  def self.save_cache_by_id dungeon_id
    Rails.cache.write("#{CACHE_PREFIX}#{CACHE_MAX}", Dungeon.count)
    Rails.cache.write("#{CACHE_PREFIX}#{dungeon_id}", DungeonMap.where(dungeon_id: dungeon_id).all)
  end

  def self.get_count_with_cache
    cache = Rails.cache.read("#{CACHE_PREFIX}#{CACHE_MAX}")
    return cache unless cache.nil?
    count = Dungeon.count
    Rails.cache.write("#{CACHE_PREFIX}#{CACHE_MAX}", count)
    count
  end

  def self.get_by_dungeon_id dungeon_id
    cache = Rails.cache.read("#{CACHE_PREFIX}#{dungeon_id}")
    return cache unless cache.nil?
    self.save_cache_by_id dungeon_id
    DungeonMap.where(dungeon_id: dungeon_id).all
  end

  def self.get_xy_by_dungeon_id dungeon_id
    map_datas = self.get_by_dungeon_id dungeon_id
    maps = Array.new(ONE_LINE).map{ Array.new(ONE_LINE, false) }
    map_datas.each do |map|
      maps[map.x][map.y] = map
    end
    maps
  end

  def self.get_default_enemy_xy_by_dungeon_id dungeon_id
    enemy = []
    xy_map = self.get_xy_by_dungeon_id dungeon_id
    xy_map.each_with_index do |line, x|
      line.each_with_index do |obj, y|
        enemy << [x,y] if xy_map[x][y].type == DungeonMap::MAP_TYPE_ENEMY
      end
    end
    enemy
  end
end
