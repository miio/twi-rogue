class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :access_token, :access_secret
  CACHE_PREFIX = "user"
  CACHE_AUTH_PREFIX = "omniauth_"
  SHARD_MAX = 2
  SHARD_PREFIX = "user_"

  def self.create_omniauth omniauth
    self.transaction do
      user = User.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      if user.nil?
        user = User.new
        user.provider = omniauth['provider']
        user.uid = omniauth['uid']
        user.access_token = omniauth['credentials']['token']
        user.access_secret = omniauth['credentials']['secret']
        #self.shard_to = Random.new.rand 1..SHARD_MAX
        user.save!
      end
      self.create_user_info(omniauth, user)
      return UserInfo.find user
    end
  end

#  def self_db
#    self.user_db self.id
#  end
#
#  def user_db user_id
#    user = Rails.cache.read("#{CACHE_PREFIX}#{user_id}")
#    user = User.find(user_id) if user.empty?
#    "#{SHARD_PREFIX}#{user.shard_to}"
#  end

  def self.create_user_info omniauth, user
      user_info = UserInfo.where(user_id: user.id).first_or_create! self.get_user_info_args(omniauth, user)
      UserInfo.shards_transaction([user_info]) do
        UserStatus.where(user_id: user.id).first_or_create! user_id: user.id
        UserMoney.where(user_id: user.id).first_or_create! user_id: user.id
      end
      Rails.cache.write("#{CACHE_PREFIX}#{user.id}", { user: user, user_info: user_info })
      return user_info
  end

  def self.get_by_user_id user_id
    cache = Rails.cache.read("#{CACHE_PREFIX}#{user_id}")
    return cache unless cache.empty?
    user = User.find user_id
    user_info = UserInfo.find_by_id user_id
    { user: user, user_info: user_info }
  end

  def self.get_user_info_args omniauth, user
    data = omniauth['extra']['raw_info']
    {
      user_id: user.id,
      screen_name: data['screen_name'],
      bio: data['description'],
      image_url: data['profile_image_url'],
      web_url: data['url']
    }
  end

  # TODO: recache method for cache cleard.
end
