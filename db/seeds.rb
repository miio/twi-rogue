# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
@field_str = <<EOM
##########
#..#..#..#
#..E...#.#
#...##...#
#..#..#..#
#..#..#..#
#......E.#
#.#.###..#
#...#.E..#
##########
EOM
@field = @field_str.lines.map do |x|
  x.chomp.split(//).map do |x|
    case x
    when "#"
    DungeonMap::MAP_TYPE_WALL
    when "."
    DungeonMap::MAP_TYPE_NONE
    when "E"
    DungeonMap::MAP_TYPE_ENEMY
    end
  end
end

def execute
  npc_enemy()
  dungeon_map()
  dungeon_enemy()
end

def npc_enemy
  enemys = [
    {id: 1, attack: 6, speed: 2, hp: 200, lv: 3},
    {id: 2, attack: 4, speed: 2, hp: 100, lv: 2},
    {id: 3, attack: 2, speed: 2, hp: 50, lv: 1}
  ]
  enemys.each do |e|
    enemy = NpcEnemy.where(id: e[:id]).first_or_initialize
    enemy.id = e[:id]
    enemy.attack = e[:attack]
    enemy.speed = e[:speed]
    enemy.hp = e[:hp]
    enemy.lv = e[:lv]
    enemy.save!
  end
end

def dungeon_map
  dungeon = Dungeon.where(id: 1).first_or_create
  @field.each_with_index do |line, y|
    line.each_with_index do |type, x|
      map = DungeonMap.where(dungeon_id: dungeon.id, x: x, y: y).first_or_initialize
      map.dungeon = dungeon
      map.type = type
      map.x = x
      map.y = y
      map.save!
    end
  end
  dungeon.save_cache
end

def dungeon_enemy
  dungeon = Dungeon.find(1)
  enemys = [
    {id: 1, dungeon: dungeon, npc_enemy: NpcEnemy.find(1)},
    {id: 2, dungeon: dungeon, npc_enemy: NpcEnemy.find(2)},
    {id: 3, dungeon: dungeon, npc_enemy: NpcEnemy.find(3)}
  ]
  enemys.each do |e|
    de = DungeonEnemy.where(id: e[:id]).first_or_initialize
    de.id = e[:id]
    de.dungeon = e[:dungeon]
    de.npc_enemy = e[:npc_enemy]
    de.save!
    de.save_cache
  end
end

p "Sending master..."
execute()
