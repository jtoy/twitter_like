require 'twitter'
class User < ActiveRecord::Base
  self.primary_key = "id"
  has_many :liked_tweets
  FREE = 0
  PAID = 1
  #this is a twitter user
  #
  #
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = app_token
      config.consumer_secret     = app_secret
      config.access_token        = user_token
      config.access_token_secret = user_secret
    end
  end

  #to be run every 15 minutes
  def self.remove_favorites
    User.find_each do |u|
      u.remove_favorites rescue nil
    end
  end
  def self.do_all
    User.all.each do |u|
      u.remove_old_likes
      u.update_follows
      u.update_follow_backs
      u.like_tweets
    end
  end

  def remove_favorites
    loop do
      client.favorites.each do |x|
        client.unfavorite(x) 
        puts "removed #{x}"
      end
    end
  end


  def like_tweets
    count = 0
    phrases = ["phrases you are", "interested in"]  
    #TODO skip if we have already done 1k favorites today
    since_id = liked_tweets.maximum("tweet_id")
    phrases.each do |phrase|
      options = {:count => 100,:lang => "en",:result_type => "recent",:since_id => since_id}
      results = client.search "#{phrase}",options
      results.each do |r|
        next if Follow.where(:a_id => r.user.id ,:b_id=>self.id).any?
        next if liked_tweets.where(:user_id => self.id,:twitter_user_id => r.user.id).any?
#        break if count >= 10 #for debug only
        client.favorite r
        t = LikedTweet.new
        t.tweet_id = r.id
        t.twitter_user_id = r.user.id
        t.phrase = phrase
        t.tweet = r.text
        t.user_id = self.id
        t.tweeted_at = r.created_at
        t.removed = false
        t.save
        count += 1
        puts "tweets liked: #{count}"
      end

    end
  end

  def update_follows
    ids = []
    cursor = -1
    while cursor != 0
      puts cursor
      puts ids.count
      data = client.follower_ids :cursor => cursor,:count => 5000
      #ids += data.to_h[:ids]
      data.to_h[:ids].each do |i|
        Follow.create(:a_id => i,:b_id => self.id) rescue nil
      end
      cursor = data.to_h[:next_cursor]
    end
    #ids
  end

  def update_follow_backs
    update_follows
    ids = Follow.where(:b_id => self.id).select(:a_id)
    tweets= liked_tweets.where(:user_id => self.id,:twitter_user_id => ids)
    tweets.each{|t| t.update_attribute :followed_back,true }
  end
  def conversion_rate
    liked_tweets.where(:user_id => self.id,:followed_back=> true).count.to_f / liked_tweets.where(:user_id => self.id).count.to_f
  end
  def conversion_rate_over_time
    rates = {}
    liked_tweets.each do |t|
      date = t.created_at.to_date
      rates[date] ||= {}
      rates[date][:total] ||= 0
      rates[date][:positives] ||= 0
      rates[date][:total] += 1
      rates[date][:positives] += 1 if t.followed_back
    end
    #rates.each_pair{|k,v| rates[k][:rate] = rates[k][:positives].to_f / rates[k][:total].to_f    }
    rates.inject({}) do |h,x|
      key = x[0]
      h[key] = rates[key][:positives].to_f / rates[key][:total].to_f 
      h  
    end
  end


  def remove_old_likes
    liked_tweets.where(:removed => false).where("created_at <= ?", (Time.now-2.days)).each do |t|
      begin
        r = client.unfavorite t.tweet_id
      rescue Twitter::Error::NotFound
        puts "already removed this tweet"
      end
      t.update_attribute :removed, true
    end
  end



end
