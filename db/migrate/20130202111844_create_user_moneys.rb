class CreateUserMoneys < ActiveRecord::Migration
  clusters :user_cluster
  def change
    create_table :user_moneys, primary_key: :user_id do |t|
      t.references :user
      t.integer :money

      t.timestamps
    end
  end
end
