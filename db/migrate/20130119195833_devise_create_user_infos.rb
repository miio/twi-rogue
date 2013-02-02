class DeviseCreateUserInfos < ActiveRecord::Migration
  clusters :user_cluster

  def change
    create_table(:user_infos, primary_key: :user_id) do |t|
      ## Trackable
#      t.references :user
      t.string :screen_name
      t.string :bio
      t.string :image_url
      t.string :web_url
      t.string :last_tid
      t.integer :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.timestamps
    end

  end
end
