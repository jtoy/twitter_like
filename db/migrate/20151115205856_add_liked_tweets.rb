class AddLikedTweets < ActiveRecord::Migration
  def change
    create_table :liked_tweets do |t|
      t.timestamps
      t.integer :tweet_id, :limit => 8
      t.integer :twitter_user_id, :limit => 8
      t.integer :user_id
      t.boolean :removed,:followed_back
      t.string :tweet,:phrase
      t.timestamp :tweeted_at
    end
  end
end
