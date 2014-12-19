require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"
require "json"
require 'httparty'

t=open("foxnews2.txt", "wb")
maxt = "2014-03-07T08:00:31Z"
(1..20).step(1)do |n|
sleep 1+rand(10)
URL = "http://www.foxnews.com/feeds/web/tech/component/latest-news/feed/json/?rows=50&callback=FX_LM&max_date="+maxt
data = JSON.parse(open(URL).read[/{.+}/])

maxt= data['response']['docs'][49]['date']
puts maxt
(0..49).step(1)do |a|
puts data['response']['docs'][a]['url']
t.write(data['response']['docs'][a]['url']) 
t.write(", \n") 
end
end