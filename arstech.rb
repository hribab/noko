require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"


t=open("arstech.txt", "wb")

(2..192).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://arstechnica.com/page/#{n}/"))

doc.css(".heading").each do |item|
 if (item != nil && item.at_css('a') != nil)  then
        
        puts item.at_css('a')['href']
        t.write(item.at_css('a')['href']) 
        t.write(", \n") 
       
        
     end
  end
end