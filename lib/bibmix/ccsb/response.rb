require 'bibmix'
require 'rexml/document' 

module Bibmix
	module Ccsb
		
		class Response < Bibmix::AbstractResponse
			include DesignByContract
			
			attr_reader :raw_response, :doc
			
			def initialize(response = nil)			
				parse(response) if not response.nil?
			end
			
			post(	'Property @raw_response should not be nil') {!@raw_response.nil?}
			post(	'Property @doc should not be nil') {!@doc.nil?}
			post(	'Return value should be an Array') { |result, response| result.is_a?(Array) }
			def parse(response)
				@raw_response = response
				@doc = response
				@result = []
			end
			
			# Returns an array of records from the given xml.
			pre(	'Property @raw_response should not be nil') {!@raw_response.nil?}
			pre(	'Property @doc should not be nil') {!@doc.nil?}
			post(	'Return value should be an Array of Bibmix::CollectedReference instances') { |result| result.is_a?(Array) && result.inject(true){|is_a,item| is_a && item.is_a?(Bibmix::CollectedReference) } }
			def get
								
				if @result.empty?
					@result = []
					@doc.each do |html|
						@result << Bibmix::CollectedReference.new(get_reference(html), 'ccsb')
					end
				end
				
				@result
			end
			
			# Allows to loop over the response.
			def each(&block)
			  self.get.each &block
			end
			
			# Returns the status based on the response xml.
			def status
				true
			end
								
		protected
						
			def parse_entry_html(html, bibutils=false)
				bibtex = clean_entry(html)
				
				if !bibutils
					result = nil
					begin
						Bibtex::Parser.parse_string(bibtex).map do |entry|
						  result = entry
						end
					rescue
						puts html,'-------', bibtex
						parse_entry_html(html, true) 
					end
				else
					
					tmp = Tempfile.new("bibutils_tmp")
			    tmp.binmode
			    tmp.puts(bibtex)
			    tmp.close()
			    
					
					xml = `~/Downloads/bibutils_4.8/bib2xml #{tmp.path()}`
					tmp.unlink
					tmp = Tempfile.new("bibutils_tmp")
			    tmp.binmode
			    tmp.puts(xml)
			    tmp.close()
					bibtex = `~/Downloads/bibutils_4.8/xml2bib #{tmp.path()}`
										
					tmp.unlink
					
					result = nil
					Bibtex::Parser.parse_string(bibtex).map do |entry|
					  result = entry
					end
				end
					
				result
			end
			
			def clean_entry(bibtex)
				
	    	ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	    	bibtex = ic.iconv(bibtex << ' ')[0..-2]
	    	
				bibtex = bibtex.gsub(/<.*?>/,'')
				bibtex = bibtex.gsub(/^@(.*?)\{.*?(,[\s\S]*)/,'@\1{bibtex\2')
				bibtex = bibtex.gsub(/([\s\S]*?),\s*\}\s*$/, '\1}')
				bibtex = bibtex.gsub(/("[\s\S]*?)\{\"\}([\s\S]*?)\{\"\}([\s\S]*?)/, '\1\2\3')	
				bibtex = bibtex.gsub(/\{"\}/,'')
#				bibtex = bibtex.gsub(/\s+#.*?,\s/, ',')
				bibtex = bibtex.gsub(/\s+#.*,\s*$/, ',')
				
				bibtex = bibtex.gsub(/url.alt\s+=/, 'urlalt')
				bibtex = bibtex.gsub(/\{\\["']\{?[aeiuoAEIOU].*?\}?\}/) {|match, x|
					result = match
					if match.include?('a')
						result = 'ä'
					elsif match.include?('u')
						result = 'ü'
					elsif match.include?('e')
						result = 'ë'
					elsif match.include?('o')
						result = 'ö'
					elsif match.include?('i')
						result = 'ï'
					elsif match.include?('A')
						result = 'Ü'
					elsif match.include?('U')
						result = 'Ü'
					elsif match.include?('E')
						result = 'Ë'
					elsif match.include?('O')
						result = 'Ö'
					elsif match.include?('I')
						result = 'Ï'
					end
					result
				}
			end
			
			# Transforms an xml entry into a Bibsonomy::Record.
			def get_reference(html)
				
				entry = parse_entry_html(html)
				Reference.from_bibtex(entry)
			end
			
		end
	end
end