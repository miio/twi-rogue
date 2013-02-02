class CreateUserGameReports < ActiveRecord::Migration
  clusters :user_cluster
  def change
    create_table :user_game_reports do |t|
      t.references :user_game
      t.text :body

      t.timestamps
    end
    add_index :user_game_reports, :user_game_id
  end
end
