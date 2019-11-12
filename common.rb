require "active_record"
require 'open-uri'
require 'nokogiri'
require "logger"
require 'pp'

dbname = 'nogizaka'
host = '127.0.0.1'
user = 'root'
pass = ''
ActiveRecord::Base.logger = Logger.new(STDOUT)
# DB接続処理
ActiveRecord::Base.establish_connection(
  :adapter  => 'mysql2',
  :database => dbname,
  :host     => host,
  :username => user,
  :password => pass,
  :encoding => 'utf8mb4',
  :charset  => 'utf8mb4'
)
# DBのタイムゾーン設定
Time.zone_default =  Time.find_zone! 'Tokyo' # config.time_zone
ActiveRecord::Base.default_timezone = :local # config.active_record.default_timezone

class Member < ActiveRecord::Base; end
class BlogArticle < ActiveRecord::Base; end
