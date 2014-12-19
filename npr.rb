require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"


t=open("npr.txt", "wb")

(1..1500).step(15) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://www.npr.org/sections/technology/archive?&start=#{n}&date=11-30-2014"))

doc.css(".dv-item").each do |item|
 if (item != nil)  then
        
        puts item.at_css('a')['href']
        t.write(item.at_css('a')['href']) 
        t.write(", \n") 
       
        
     end
  end
end