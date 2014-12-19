require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"
require 'active_support/core_ext'

t=open("businessinsider.txt", "wb")

d= Date.new(2014,1,1)
(1..364).step(1) do |n| 
puts n
d=d+1
doc=Nokogiri::HTML(open("http://www.businessinsider.com/archives?vertical=sai&date=#{d.to_s}"))

 doc.css("td").each do |item|
 if (item != nil && item.at_css('a') != nil)  then
        
        puts "http://www.businessinsider.com"+item.at_css('a')['href']
        t.write("http://www.businessinsider.com"+item.at_css('a')['href']) 
        t.write(", \n") 
       
        
     end
     
  end
end