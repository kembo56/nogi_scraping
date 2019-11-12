require_relative 'common.rb'

@ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"

def parse_top_page
  members_url = 'http://www.nogizaka46.com/member/'
  member_detail_urls = []
  sleep 1
  html = open(members_url,"user-agent"=>@ua).read
  doc = Nokogiri::HTML::parse(html, nil, 'utf-8')
  doc.at_css('div#memberlist').css('div.unit').each do |member_unit|
    member_detail_urls << URI::join(members_url,member_unit.at_css('a').attribute('href').value).to_s
  end
  return member_detail_urls
end

def parse_detail_page(url)
  sleep 1
  html = open(url,"user-agent"=>@ua).read
  doc = Nokogiri::HTML::parse(html, nil, 'utf-8')
  detail_ele = doc.at_css('div#profile')
  detail_txt = detail_ele.at_css('div.txt')
  name_kana = detail_txt.at_css('h2').at_css('span').text
  name = detail_txt.at_css('h2').text[name_kana.size..-1]
  member_hash = {
    'name' => name.gsub(' ',''),
    'name_english' => url.split('/')[-1].split('.')[0],
    'img_url' => detail_ele.at_css('img').attribute('src').value,
    'birthday' => detail_txt.css('dd')[0].text,
    'blood_type' => detail_txt.css('dd')[1].text,
    'twelve_signs' => detail_txt.css('dd')[2].text,
    'height' => detail_txt.css('dd')[3].text,
    'term' => detail_txt.at_css('div.status').css('div')[0].text
  }
end

def parse_wiki
  wiki_url = "https://ja.wikipedia.org/wiki/%E4%B9%83%E6%9C%A8%E5%9D%8246"
  html = open(wiki_url,"user-agent"=>@ua).read
  doc = Nokogiri::HTML::parse(html, nil, 'utf-8')
  member_birthplace = {}
  first_table = doc.at_css('table.wikitable')
  first_table.css('tr')[1..-1].each do |row|
    member_birthplace[row.css('td')[0].text] = row.css('td')[3].text
  end
  yonki_table = doc.css('table.wikitable')[1]
  yonki_table.css('tr')[1..-1].each do |row|
    member_birthplace[row.css('td')[0].text] = row.css('td')[3].text
  end
  return member_birthplace
end

member_detail_urls = parse_top_page
birth_place_hash = parse_wiki
member_detail_urls.each do |url|
  member_hash = parse_detail_page(url)
  member_hash['birthplace'] = birth_place_hash[member_hash['name']]
  Member.create(member_hash)
end
