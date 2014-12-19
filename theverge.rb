require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"

t=open("theverge.txt", "wb")

(2..478).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://www.theverge.com/tech/archives/#{n}/"))

doc.css(".body").each do |item|
 if (item != nil)  then
        
        puts item.at_css('h3>a')['href']
        t.write(item.at_css('h3>a')['href']) 
        t.write(", \n") 
       
        
     end
     
  end
  
end