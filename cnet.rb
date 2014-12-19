require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"


t=open("cnet.txt", "wb")

(2..1230).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://www.cnet.com/news/#{n}/"))

doc.css(".assetHed").each do |item|
 if (item != nil)  then
        
        puts "http://www.cnet.com"+item['href']
        t.write("http://www.cnet.com"+item['href']) 
        t.write(", \n") 
       
        
     end
  end
end