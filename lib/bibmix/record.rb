require 'bibmix'

module Bibmix
	
	class RecordError < Bibmix::Error
	end
	
	class InvalidEntryTypeError < RecordError
	end

	class RecordInvalidMergeParamError < RecordError
	end
	
	# Record class which is a datawrapper for all valid bibtex fields, the type of
	# entry, tags, a hash identifier and the complete citation string from which
	# the data originates from.
	class Record
		
		@@attributes = [
			# Valid bibtex fields
			:address, :annotate, :author,
			:booktitle, :chapter, :crossref,
			:edition, :editor, :howpublished,
			:institution, :journal, :key,
			:month, :note, :number,
			:organization, :pages, :publisher,
			:school, :series, :title,
			:type, :volume, :year,
			# Fields also returned by bibsonomy, but are useful for other APIs as well.
			:entrytype, :tags, :intrahash,
			# The complete citation string, if any.
			:citation		
		]

		attr_accessor *@@attributes
		
		# Returns an array of attributes of the record.
		def get_attributes
			@@attributes
		end
		
		# Allows to loop over the attribute keys of the record.
		def each(&block)
			values = {}
			each_attribute do |attr|
				value = self.fetch(attr)
				if not value.nil?
					values[attr] = value
				end
			end
		  @@attributes.each &block
		end
		
		# Allows to loop over the attribute keys of the record.
		def each_attribute(&block)
		  @@attributes.each &block
		end
		
		# A setter for entrytype which makes sure the entry type value is a valid one.
		def entrytype=(value)
			valid_entry_types = [
				'article', 'book', 'booklet',
				'conference', 'inbook', 'incollection',
				'inproceedings', 'manual', 'mastersthesis',
				'misc', 'phdthesis', 'proceedings',
				'techreport', 'unpublished'
			]
			
			if !valid_entry_types.include?(value)
				Rails.logger.warn "Invalid entry type found (#{value})"
			end
			
			@entrytype = value
		end
		
		# A setter for tags which makes sure the tags are hashes.
		def tags=(value)
						
			if value.class != Hash
				Rails.logger.warn "Tags have invalid type (#{value.class})"
			end
			
			@tags = value
		end
		
		# Setter for 'author' which makes sure the author is an array.
		def author=(value)
			
			if value.class == String
				value = split_authors(value)
			end
			
			if value.class != Array
				Rails.logger.warn "Author has an invalid type (#{value.class}, #{value})"
			end
			
			@author = value
		end
		
		def fetch(key, default=nil)
			val = self.send(key)
			
			val || default
		end
		
		# Creates a record from a hash.
		def self.from_hash(hsh)
			record = Bibmix::Record.new
			
			hsh.each do |key, value|
				if value.kind_of?(String)
					record.send("#{key}=", value.strip)
				else
					record.send("#{key}=", value)
				end
			end
			
			record
		end
		
		# Merges the current record with the given record.
		def merge(record)
			raise RecordInvalidMergeParamError unless record.kind_of?(Bibmix::Record)
			
			each_attribute do |attr|
				if self.send(attr).nil? && !record.send(attr).nil?
					self.send("#{attr}=", record.send(attr))
				end
			end
			
			self
		end
		
		def method_missing(method, *args)
			
			if ENV["RAILS_ENV"] == "test"
				name = method.to_s
   			aname = name.sub("=","")
				
				if !@@attributes.include?(aname) || !@@attributes.include?(method)
		#			Rails.logger.debug "Method missing: (#{aname})"
				end
			end
			
		end
		
		# To string method for pretty printing the record.
		def to_s
			"<Bibmix::Record(#{@title})>"
		end
	
		protected	 
		def split_authors(authors)
			result = []
			authors.split(' and ').each do |author|
				result << author
			end
			result
		end
	end
end