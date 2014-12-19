require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"
require "restclient"

i=0
File.open("businesswire2014.csv").readlines.each do |line|
  t=open("bwall.txt", "a")
  puts i
     title=""
    tim=""
    contact=""
    author=""
    line2="http://haribabu:Wo0sVXeBGQ@paygo.crawlera.com:8010/fetch?url="+line
    #doc=Nokogiri::HTML(open(line2))
    begin
    doc=Nokogiri::HTML(RestClient.get(line2))
   
   if(doc.css(".bw-release-contact p") != nil) then 
   doc.css(".bw-release-contact p").each do |item2|
          
          if (item2 != nil)  then
          contact=item2
          if(item2.css("br")[0] != nil) then
          author=item2.css("br")[0].next.text.partition(",")[0]
          else author= "businesswire"
          end
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
       puts line+","+title+","+tim+","+contact+","+author
        t.write(line+"----"+title+"----"+tim+"----"+contact+"----"+author)
          t.write("\n") 
          t.close();
          
        #t.write("http://www.businesswire.com/"+item['href']) 
        #t.write(", \n") 
        sleep 1
     
  
   i=i+1
   end
   rescue
   next
   end
   
end

