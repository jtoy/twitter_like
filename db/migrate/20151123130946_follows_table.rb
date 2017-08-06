class FollowsTable < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :a_id,:limit => 8
      t.integer :b_id,:limit => 8
    end
    add_index :follows, [:a_id, :b_id], unique: true
    add_index :follows, :b_id

  end
end
