require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"

t=open("mashable.txt", "wb")

(2..608).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://mashable.com/2014/?page=#{n}"))

doc.css("header").each do |item|
  if (item != nil)  then
       # if (item.at_css(".article-category").text == "Tech" || item.at_css(".article-category").text == "Social Media" || item.at_css(".article-category").text == "Business" ) then
        #puts item.xpath("//a").text
       if( item.xpath("//a[@class='article-category']").text <=> "Tech" || item.xpath("//a[@class='article-category']").text <=> "Social Media" ||  item.xpath("//a[@class='article-category']").text <=> "Business" ) then
        
         puts item.css(".article-title").at_css('a')
       # puts hr.at_css('a')['href']
        
        #puts item.xpath("//h1[@class='article-category']").text
        
        #puts item.css('a')['href']
        t.write(item.css(".article-title").at_css('a')) 
        t.write(",\n") 
       
           end        
     end
  end
end