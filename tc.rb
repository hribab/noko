require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"

t=open("list3.txt", "wb")

(2..383).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://techcrunch.com/2014/page/#{n}/"))

doc.css(".post-title").each do |item|
 if (item != nil)  then
        
        puts item.at_css('a')['href']
        t.write(item.at_css('a')['href']) 
        t.write(", \n") 
       
        
     end
  end
end