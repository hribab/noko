require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"


t=open("bwall.txt", "wb")

(2..260).step(1) do |n| 
  puts n
  doc=Nokogiri::HTML(open("http://www.businesswire.com/portal/site/home/template.PAGE/news/industry/?javax.portlet.prp_08c2aa13f2fe3d4dc1b6751ae1de75dd_ndmHsc=v2*A1414929600000*DgroupByDate*G#{n}*M31121*N1000017"))
  begin
doc.css(".bwTitleLink").each do |item|
 if (item != nil)  then
        
        #puts item.at_css('a')['href']
        if(item['href'][26..27] == 'en') then
        puts item['href']
        ur="http://www.businesswire.com/"+item['href']
        title=""
          tim=""
          contact=""
          author=""
        doc=Nokogiri::HTML(open(ur))
        doc.css(".bw-release-contact p").each do |item2|
          
          if (item2 != nil)  then
          contact=item2
          author=item2.css("br")[0].next.text.partition(",")[0]
          end
        end
        
        doc.css(".bw-release-timestamp").each do |item2|
          if (item2 != nil)  then
          tim=item2
          end
        end
        
        doc.css("//title").each do |item2|
          if (item2 != nil)  then
          title=item2
          end
                   
        end
        c << [ur+","+title+","+tim+","+contact+","+author]
        c << ", \n"
        t.write(ur+","+title+","+tim+","+contact+","+author)
          t.write(", \n") 
        #t.write("http://www.businesswire.com/"+item['href']) 
        #t.write(", \n") 
        
        end
     end
  end
  rescue
    sleep 300
  end
end