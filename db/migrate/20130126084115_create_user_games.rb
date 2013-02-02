class CreateUserGames < ActiveRecord::Migration
  clusters :user_cluster
  def change
    create_table :user_games do |t|
      t.references :user
      t.references :dungeon
      t.integer :status

      t.timestamps
    end
    create_sequence_for(:user_games)
    add_index :user_games, :user_id
    add_index :user_games, :dungeon_id
  end
end
