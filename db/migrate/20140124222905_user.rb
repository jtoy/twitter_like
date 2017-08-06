class User < ActiveRecord::Migration
  def change
    create_table :users,:id => false do |t|
      t.timestamps
      t.integer :kind #0 free, 1 paid, 2 is forever
      t.string :user_token,:user_secret,:app_token,:app_secret,:stripe_id,:email,:screen_name
      t.integer :id, :limit => 8
    end
  end
end
