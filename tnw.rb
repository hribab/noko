require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"

t=open("tnw.txt", "wb")

(2..612).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://thenextweb.com/2014/page/#{n}/"))

doc.css(".loop-post-image").each do |item|
 if (item != nil)  then
        
        puts item.at_css('a')['href']
        t.write(item.at_css('a')['href']) 
        t.write(", \n") 
       
        
     end
  end
end