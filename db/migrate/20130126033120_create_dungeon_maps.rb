class CreateDungeonMaps < ActiveRecord::Migration
  clusters :user_cluster
  def change
    create_table :dungeon_maps do |t|
      t.references :dungeon
      t.integer :type
      t.integer :x
      t.integer :y

      t.timestamps
    end
    add_index :dungeon_maps, :dungeon_id
  end
end
