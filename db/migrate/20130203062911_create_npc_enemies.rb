class CreateNpcEnemies < ActiveRecord::Migration
  def change
    create_table :npc_enemies do |t|
      t.integer :attack
      t.integer :speed
      t.integer :hp
      t.integer :lv

      t.timestamps
    end
  end
end
