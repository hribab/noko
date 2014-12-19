require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"

t=open("list.txt", "wb")

1.upto(165) do |pagenum|
  doc=Nokogiri::HTML(open("http://www.askme.com/hyderabad/furniture-stores-multi-range/ipage/#{pagenum}"))



doc.css(".listing_data_right").each do |item|
 if (item != nil)  then
  if( item.at_css(".listing_cont_name") !=nil) then  t.write(item.at_css(".listing_cont_name").text) end
  if(item.at_css(".listing_cont_number") !=nil) then t.write(item.at_css(".listing_cont_number").text) end
  if(item.at_css(".listing_cont_email") !=nil) then  t.write(item.at_css(".listing_cont_email").text) end
  end

end

end

t.close