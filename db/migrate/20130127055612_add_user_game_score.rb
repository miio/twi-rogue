class AddUserGameScore < ActiveRecord::Migration
  clusters :user_cluster
  def change
    add_column :user_games, :score, :integer
    add_index :user_games, :score
  end
end
