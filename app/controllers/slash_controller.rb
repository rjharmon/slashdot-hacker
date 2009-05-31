class SlashController < ApplicationController
  
  def read
    require 'rss/1.0'
    require 'rss/2.0'
    require 'open-uri'

    source = 'http://rss.slashdot.org/Slashdot/slashdot'

    content = "" # raw content of rss feed will be loaded here

    open(source) do |s| 
    	content = s.read 
    end

    rss = RSS::Parser.parse(content, false)


    rss.items.each do |item|
    	t = item.to_s
    	t =~ /<item rdf:about="(.*?)">/
    	t = $1
    	item.link = t
    	
    	t = item.description
    	t.sub! /<p>.*/im, ""
    	logger.info t
    	item.description = t
    end

    render :text => rss.to_s
  end
end
