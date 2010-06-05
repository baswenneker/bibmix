require 'bibmix'

module Bibmix

	module Bibsonomy
	
		# Record class which is a datawrapper for all valid bibtex fields, the type of
		# entry, tags, a hash identifier and the complete citation string from which
		# the data originates from.
		class Record < Bibmix::Record
			
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
			
			# Create getters and setters for the given attributes.
			attr_accessor *@@attributes
			
			def id
				if !@intrahash
					raise Bibmix::Error, 'No intrahash identifier present'
				end
				@intrahash
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
				
				Rails.logger.info("Invalid entry type found (#{value})") if !valid_entry_types.include?(value)
				@entrytype = value
			end
			
			# A setter for tags which makes sure the tags are hashes.
			def tags=(value)
				raise Bibmix::RecordError.new("Tags have invalid type (#{value.class})") if value.class != Hash
				@tags = value
			end
			
			# Setter for 'author' which makes sure the author is an array.
			def author=(value)
				
				if value.class == String
					value = split_authors(value)
				end
				
				raise Bibmix::RecordError.new("Author has an invalid type (#{value.class}, #{value})") if value.class != Array
				@author = value
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
end