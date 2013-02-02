require 'redis'
require 'redis/objects'
# if you are also using a list or any other complex object, please make sure to "require 'redis/list'" respectively
Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)
Redis.current.ping
