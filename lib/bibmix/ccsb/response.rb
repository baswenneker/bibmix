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
						
			def parse_entry_html(html)
				bibtex = clean_entry(html)
				
				result = nil
				Bibtex::Parser.parse_string(bibtex).map do |entry|
				  result = entry
				end
				
				result
			end
			
			def clean_entry(bibtex)
				bibtex = bibtex.gsub(/<.*?>/,'')
				bibtex = bibtex.gsub(/^@(.*?)\{.*?(,[\s\S]*)/,'@\1{bibtex\2')
				bibtex = bibtex.gsub(/([\s\S]*?),\s*\}\s*$/, '\1}')
				bibtex = bibtex.gsub(/("[\s\S]*?)\{\"\}([\s\S]*?)\{\"\}([\s\S]*?)/, '\1\2\3')	
				bibtex = bibtex.gsub(/\{"\}/,'')
			end
			
			# Transforms an xml entry into a Bibsonomy::Record.
			def get_reference(html)
				
				entry = parse_entry_html(html)
				Reference.from_bibtex(entry)
			end
			
		end
	end
end