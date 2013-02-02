class CreateUserStatuses < ActiveRecord::Migration
  clusters :user_cluster
  def change
    create_table :user_statuses, primary_key: :user_id do |t|
      t.references :user
      t.integer :attack
      t.integer :speed
      t.integer :hp
      t.integer :lv

      t.timestamps
    end
    create_sequence_for(:user_statuses)
  end
end
