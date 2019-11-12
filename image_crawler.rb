require_relative 'common.rb'
require 'pp'
require 'net/http'
require 'open-uri'


ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"

BlogArticle.where(member_name: ARGV[0]).find_each do |blog_record|
  member_name_english = Member.find_by(id: blog_record['member_id'])['name_english']
  dir_name = "img/#{member_name_english}"
  unless Dir.exist?(dir_name)
    Dir.mkdir(dir_name)
  end
  blog_record['image_urls'].split().each do |image_url|
    file_name = "#{dir_name}/#{image_url.split('/')[-5..-1].join('')}"
    sleep 2
    begin
      open(file_name, 'wb') do |file|
        file.puts(open(URI.parse(image_url),"user-agent"=>ua).read)
      end
    rescue => e
      open('error_img.log', 'a') do |f|
        f.puts(image_url)
      end
      pp e.message
    end
  end
end
