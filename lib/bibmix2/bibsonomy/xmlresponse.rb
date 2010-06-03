require 'bibmix/bibsonomy'
require 'rexml/document' 

module Bibmix
	module Bibsonomy
		
		class ResponseError < Bibmix::Error
		end
	
		class InvariantError < ResponseError
		end
		
		class XMLResponse < Bibmix::Response
			
			attr_reader :raw_response, :doc
			
			def initialize(response = nil)			
				parse(response) if not response.nil?
			end
			
			def parse(response)
				@raw_response = response
				@doc = REXML::Document.new(response)
				@result = nil
				raise InvariantError if not invariant
			end
			
			# Returns an array of records from the given xml.
			def get
				raise InvariantError unless invariant
				
				if @result.nil?
					@result = []
					REXML::XPath.each(@doc, "//posts/post") do |post|
						record = get_record(post)
						record.send("tags=", get_tags_of_entry(post))
						@result << record
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
				bibsonomy = REXML::XPath.first(@doc, "//bibsonomy")
				bibsonomy.attributes['stat']
			end
			
			# Returns the number of returned post entries.
			def size
				return self.get.size
			end
					
		protected
			def invariant
				!@raw_response.nil? && !@doc.nil?
			end
		
			# Transforms an xml entry into a Bibsonomy::Record.
			def get_record(entry)
				
				record = Bibmix::Record.new
				REXML::XPath.first(entry, "bibtex").attributes.each do |key, value|
					record.send("#{key.strip}=", value.strip)
				end
				
				record
			end
			
			# Returns a hash of tags of an entry.
			def get_tags_of_entry(entry)
				raise InvariantError unless invariant
				
				tags = {}
				REXML::XPath.each(entry, "tag") do |tag|
					tags[tag.attributes['href']] = tag.attributes['name']
				end
				
				tags
			end
		end
	end
end