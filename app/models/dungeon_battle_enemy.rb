class DungeonBattleEnemy
  attr_accessor :x, :y, :hp, :attack, :speed, :npc_enemy
  
  def initialize x, y, npc_enemy
    self.x = x
    self.y = y
    self.hp = npc_enemy.hp
    self.attack = npc_enemy.attack
    self.speed = npc_enemy.speed
    self.npc_enemy = npc_enemy
  end
end
