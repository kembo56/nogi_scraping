require_relative 'common.rb'
require 'time'
require 'date'

@ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"

def get_each_member_top_url
  blog_top_url = "http://blog.nogizaka46.com/"
  sleep 1
  html = open(blog_top_url,"user-agent"=>@ua).read
  doc = Nokogiri::HTML::parse(html, nil, 'utf-8')
  each_member_top_url = []
  doc.at_css('div#sidemember').css('a').each do |a|
    each_member_top_url << URI::join(blog_top_url,a.attribute('href').value).to_s
  end
  return each_member_top_url
end

def get_blog_articles(url)
  sleep 2
  html = open(url,"user-agent"=>@ua).read
  doc = Nokogiri::HTML::parse(html, nil, 'utf-8')
  return false unless doc.at_css('.twitter-share-button').attribute('data-url').value.include?('?')
  loop do
    title_eles = doc.css('h1.clearfix')
    body_eles = doc.css('div.entrybody')
    entrybottom_eles = doc.css('div.entrybottom')
    entry_cnt = title_eles.size
    for i in 0...entry_cnt
      blog_hash = create_blog_hash(title_eles[i], body_eles[i], entrybottom_eles[i])
      insert_blog_hash(blog_hash)
    end
    break if doc.at_css('div.paginate').nil? || doc.at_css('div.paginate').at_css(":contains('＞')").nil?
    next_url = url + '&' + doc.at_css('div.paginate').at_css(":contains('＞')").attribute('href').value[1..3]
    sleep 2
    html = open(next_url,"user-agent"=>@ua).read
    doc = Nokogiri::HTML::parse(html, nil, 'utf-8')
  end
end

def create_blog_hash(title_ele, body_ele, entrybottom_ele)
  img_urls = []
  body_ele.css('img').each do |img_ele|
    img_urls << img_ele.attribute('src')&.value
  end
  img_urls = img_urls.join(" ")
  blog_hash = {
    'title' => title_ele.at_css('span.entrytitle').text,
    'member_name' => title_ele.at_css('span.author').text,
    'page_url' => title_ele.at_css('a').attribute('href').value,
    'day_of_the_week' => title_ele.at_css('span.dd2').text,
    'body' => body_ele.text,
    'image_urls' => img_urls,
    'uploded_at' => Time.parse(entrybottom_ele.at_css('text()').text),
    'comment_url' => entrybottom_ele.css('a')[1].attribute('href').value,
    'comment_cnt' => entrybottom_ele.css('a')[1].text.delete("^0-9").to_i
  }
end

def insert_blog_hash(blog_hash)
  case blog_hash['member_name']
  when '４期生','３期生','研究生' then
    Member.all.each do |member|
      next unless blog_hash['title'].include?(member['name'])
      blog_hash['member_name'] = member['name']
      blog_hash['member_id'] = member['id']
    end
  when '運営スタッフ' then
    blog_hash['member_id'] = 100
  else
    begin
      member_record = Member.find_by(name: blog_hash['member_name'])
      blog_hash['member_id'] = member_record['id']
    rescue => e
      pp blog_hash['member_name']
    end
  end
  return if record_existing?(BlogArticle,blog_hash)
  BlogArticle.create(blog_hash)

end

def record_existing?(class_name,hash)
  same_record = class_name.find_by(hash)
  return same_record.present?
end


def main(month)
  each_member_top_url = get_each_member_top_url
  d = Date.today
  months = []
  loop do
    str = d.strftime("%Y%m")
    break if str == month
    break if str.to_i <= 201109
    months << str
    d = d << 1
  end
  cnt = 0
  each_member_top_url.each do |top_url|
    cnt += 1
    next if cnt <= 14
    months.each do |month|
      url = top_url + '?d=' + month
      get_blog_articles(url)
    end
  end
end


require 'optparse'

month = '201110'
OptionParser.new do |opt|
  opt.on('-m','--month ARG','last scraping month') {|m| month = m}

  opt.parse!(ARGV)
end

main(month)
