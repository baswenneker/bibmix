require 'bibmix'
require 'rubygems'
require 'hpricot'
require 'bibtex'
require 'open-uri'

module Bibmix
	module Ccsb
		
		class RequestError < Bibmix::Error; end
		class Request < Bibmix::CacheRequest
			include DesignByContract			
			
	    def initialize
	    	init_config
	   	end
	   	
	   	# Initializes the configuration used to query ccsb.
	   	def init_config
	    	@use_caching = Bibmix::get_config('request_caching', true)
	    	# CCSB shows relevance numbers next to search results, only try to integrate results
    		# with a higher relevance than stated below.
    		@request_relevance_threshold = Bibmix::get_config('ccsb_request_relevance_threshold', 50)
	   	end
	   	
	   	pre( 'Parameter title is should not be empty') {|title| title.is_a?(String) && !title.empty? }
	   	def send(title)		  
	   		
	   		title = CGI.escape(title.gsub(/\s*-\s*/,' '))
			  result_page_request_uri = "http://liinwww.ira.uka.de/csbib?query=#{title}"
			  begin
			  	response = do_request(result_page_request_uri)
			  rescue Error => e
			  	raise RequestError, "Error while requesting data (#{e})."
			  end
			  
			  begin
			  	result = process_response(response)
			  rescue Error => e
			  	raise RequestError, "Error while processing response (#{e})."
			 	end
			 
			 	result
			end
	  
	  protected
		  def do_request(url)
		  	Bibmix.log(self, "url = #{url}")
		  
		  	if @use_caching
				  doc = from_cache(url)
				  if doc.nil?
				  	doc = Hpricot(open(url))	  	
				  	to_cache(url, doc)
				 	else
				 		doc = Hpricot(doc)
				 	end
				else
					doc = Hpricot(open(url))
				end
		  	
		  	doc
		  end
		  
		  def process_response(doc)
		  	entries = []
		  	doc.search('//table[@class="citation"]').each do |table|
					confidence = table.at('td[@class="score"]').inner_html.strip.chop.to_i
					if confidence >= @request_relevance_threshold
						
						begin
							links = table.search('td[@class="biblinks"]/a')
						rescue
							links = []
						end
						
						duplicates_href, bibtex_href = nil, nil
						links.each do |link|
							if link.attributes['href'] =~ /mode=dup/
								duplicates_href = link.attributes['href']
							elsif link.attributes['title'] == 'Full BibTeX record'
								bibtex_href = link.attributes['href']
							end
						end
						
						if duplicates_href.nil? && bibtex_href.nil?
							next
						end
						
						if !duplicates_href.nil?
							bibdoc = do_request("http://liinwww.ira.uka.de#{duplicates_href}")
							html_pres = bibdoc.search('pre[@class="bibtex"]')
							
							html_pres.each do |pre|
								entries << pre.inner_html
							end
						end
						
						if !bibtex_href.nil?
							bibdoc = do_request("http://liinwww.ira.uka.de#{bibtex_href}")
							entries << bibdoc.at('pre[@class="bibtex"]').inner_html
						end
					end
				end
				
				Bibmix::Ccsb::Response.new(entries)
			end
		end
	end
end