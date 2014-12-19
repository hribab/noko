require "rubygems"
require "nokogiri"
require "open-uri"
require "open_uri_redirections"
require "csv"
require "json"
require 'httparty'
require "openssl"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
t=open("nybits.txt", "wb")


URL = "http://bits.blogs.nytimes.com/more_posts_json/page/4/?homepage=1&apagenum=4"

#data=JSON.parse(open(URL,:allow_redirections => :safe , "User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1").read[/{.+}/])

doc=JSON.parse(open(URL, :allow_redirections => :safe, "User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1").read)

t.write(doc)
puts doc['posts'][3]
