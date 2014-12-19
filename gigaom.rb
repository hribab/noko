require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"
require "openssl"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

t=open("gigaom.txt", "wb")

(2..197).step(1) do |n| 
  puts n
  
doc=Nokogiri::HTML(open("https://gigaom.com/2014/page/#{n}/"))

doc.css(".head").each do |item|
 if (item != nil)  then
        
        puts item.at_css('a')['href']
        t.write(item.at_css('a')['href']) 
        t.write(", \n") 
       
        
     end
  end
end