class CreateDungeons < ActiveRecord::Migration
  clusters :user_cluster
  def change
    create_table :dungeons do |t|
      t.timestamps
    end
  end
end
