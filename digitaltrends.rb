require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"


t=open("digital.txt", "wb")

(1..3).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://www.digitaltrends.com/2014/page/#{n}/"))

doc.css(".title").each do |item|
 if (item != nil)  then
        
        puts item.at_css('a')['href']
        t.write(item.at_css('a')['href']) 
        t.write(", \n") 
       
        
     end
  end
end