require 'redis'

if Rails.env.development?
  REDIS = Redis.connect(url: ENV['REDISTOGO_URL'])
end