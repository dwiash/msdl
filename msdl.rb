#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
doc = Nokogiri::HTML(open(ARGV[0]))
Title 	= Array.new(doc.css('head title'))
title = Title[0].content.partition(" - ")[0]
dir = title.tr(" ","_")
Pages 	= Array.new(doc.css('#controls a'))
print "Downloading " + title
puts `mkdir #{dir}`
total_page = Pages[1..-2].length
current = 0
Pages[1..9].each do |item|
	current = current + 1
	page = Nokogiri::HTML(open("http://mangastream.com/" + item['href']))
	element = Array.new(page.css('#pagewrapper #page img#p'))
	img = element[0]['src']
	print "File #{current}/#{total_page}"
	puts `wget -q -c -P #{dir} #{img} -O #{dir}/0#{current}.png`
end
Pages[10..-2].each do |item|
	current = current + 1
	page = Nokogiri::HTML(open("http://mangastream.com/" + item['href']))
	element = Array.new(page.css('#pagewrapper #page img#p'))
	img = element[0]['src']
	print "File #{current}/#{total_page}"
	puts `wget -q -c -P #{dir} #{img} -O #{dir}/#{current}.png`
end
print `tar -cf #{dir}.tar #{dir}/`
print `bzip2 -z #{dir}.tar`
print `rm -rf #{dir}`
puts "Done, Saved to \"#{dir}\" "
