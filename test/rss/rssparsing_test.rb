require "test/unit"
require "rexml/document"
require "rubygems"
require "hpricot"
require "bibtex"
require "open-uri"
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class RSSParsingTest < ActiveSupport::TestCase
	include Bibmix::Bibsonomy
	
	def setup
		@url = 'http://liinwww.ira.uka.de/bibliography/rss?query=%22open%20source%22%20crf%20reference%20string%20parsing%20package&sort=score'
	end
	
	def test_rssparsing
		url = 'http://liinwww.ira.uka.de/csbib?query=detecting%20%22content%20bearing%22%20words%20serial%20clustering'
		doc = Hpricot(open(url))
		doc.search('//table[@class="citation"]').each do |table|
			confidence = table.at('td[@class="score"]').inner_html.strip.chop.to_i
			if confidence >= 80
				begin
					bibtex_url = table.at('td[@class="biblinks"]/a[@title="Full BibTeX record"]').attributes['href']
				rescue
					next
				end
				
				if !bibtex_url.nil?
					bibdoc = Hpricot(open("http://liinwww.ira.uka.de#{bibtex_url}"))
					bibtex = bibdoc.at('pre[@class="bibtex"]').inner_html.gsub(/<.*?>/,'')
					
					bibtex = bibtex.gsub(/^@(.*?)\{.*?(,[\s\S]*)/,'@\1{bibtex\2')
					bibtex = bibtex.gsub(/([\s\S]*?),\s*\}\s*$/, '\1}')
					bibtex = bibtex.gsub(/("[\s\S]*?)\{\"\}([\s\S]*?)\{\"\}([\s\S]*?)/, '\1\2\3')
					
					Bibtex::Parser.parse_string(bibtex).map do |entry|
					  puts entry.to_yaml
					  entry
					end
					
				end
				
			end
		end
		
	end
	
	def not_test_rssparsing
		content = Net::HTTP.get(URI.parse(@url))
		xml = REXML::Document.new(content)
		
		data = {}
		data['title'] = xml.root.elements['channel/title'].text
		data['home_url'] = xml.root.elements['channel/link'].text
		data['rss_url'] = @url
		data['items'] = []
		xml.elements.each('//item') do |item|
			it = {}
			it['title'] = item.elements['title'].text
			it['link'] = item.elements['link'].text
			it['description'] = item.elements['description'].text
			if item.elements['dc:creator']
				it['author'] = item.elements['dc:creator'].text
			end
			if item.elements['dc:date']
				it['publication_date'] = item.elements['dc:date'].text
			elsif item.elements['pubDate']
				it['publication_date'] = item.elements['pubDate'].text
			end
			data['items'] << it
		end
		data
		
		puts data
	end
	
end