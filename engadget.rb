require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"

t=open("boingboing.txt", "wb")

(116..611).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://boingboing.net/2014/page/#{n}/"))

doc.css(".post").each do |item|
 if (item != nil)  then
        
        puts item.at_css('a')['href']
        t.write(item.at_css('a')['href']) 
        t.write(", \n") 
       sleep 1+rand(100)
        
     end
     
  end
  sleep 1+rand(200)
end