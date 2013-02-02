class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :access_token
      t.string :access_secret
      t.timestamps
    end
    add_index :users, [:provider, :uid], unique: true
    add_index :users, [:provider, :access_token, :access_secret], unique: true
  end
end
