require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"


t=open("list2.txt", "wb")

(10..190).step(10) do |n| 
  
  doc=Nokogiri::HTML(open("http://www.asklaila.com/search/Hyderabad/-/furniture/#{n}?searchNearby=false&v=listing"))

doc.css(".listboxInrBox").each do |item|
 if (item != nil)  then
        doc2=Nokogiri::HTML(open(item.at_css('a')['href']))
        
      if (doc2.xpath("//table/tr/td/a/span") !=nil) then 
        puts doc2.xpath("//table/tr/td/a/span").text 
        t.write(doc2.xpath("//table/tr/td/a/span").text) 
        end
        
     end
  end
end