require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"
require "openssl"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE


t=open("vb.txt", "wb")

(2..204).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://venturebeat.com/page/#{n}/", "User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1"))

doc.css(".entry-summary-thumbnail").each do |item|
 if (item != nil)  then
        
        puts item.at_css('a')['href']
        t.write(item.at_css('a')['href']) 
        t.write(", \n") 
       
        
     end
  end
end