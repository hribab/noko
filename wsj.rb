require "rubygems"
require "nokogiri"
require "open-uri"
require "csv"
require "json"
require 'httparty'

t=open("wsj.txt", "wb")
URL = "http://online.wsj.com/news/svc/headlines?type=news&page=3&before=BL-DGB-38679&count=10&category=digits&_=1415451312522"
data = JSON.parse(open(URL).read[/[.+]/])

puts data

# copy json data to notepad++, ctrl+H, replace "tesla_url" with \n\n"tesla_url", replace "text" with \n\n"text", 
# search for "tesla_url" current document, copy results, paste in new document
