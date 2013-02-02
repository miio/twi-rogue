class CreateDungeonEnemies < ActiveRecord::Migration
  def change
    create_table :dungeon_enemies do |t|
      t.references :dungeon
      t.references :npc_enemy

      t.timestamps
    end
    add_index :dungeon_enemies, :dungeon_id
    add_index :dungeon_enemies, :npc_enemy_id
  end
end
