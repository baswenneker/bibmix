require 'bibmix'

module Bibmix

	# Reference class which is a datawrapper for all valid bibtex fields, the type of
	# entry, tags, a hash identifier and the complete citation string from which
	# the data originates from.
	class Reference < Bibmix::AbstractReference
		
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
			:entrytype, :tags, :id,
			# The complete citation string, if any.
			:citation, :merged
		]
		
		# Create getters and setters for the given attributes.
		attr_accessor *@@attributes
		
		def initialize
			super
			@merged_by = []
		end
		
		def merged_by=(merged_by)
			@merged_by = merged_by
		end
		
		def merged_by
			@merged_by
		end
		
		def id
			if !@id
				@id = rand.to_s
			end
			@id
		end
		
		# A setter for entrytype which makes sure the entry type value is a valid one.
		def entrytype=(value)
			
			value = value.downcase
			
			valid_entry_types = [
				'article', 'book', 'booklet',
				'conference', 'inbook', 'incollection',
				'inproceedings', 'manual', 'mastersthesis',
				'misc', 'phdthesis', 'proceedings',
				'techreport', 'unpublished'
			]
			
			if !valid_entry_types.include?(value)
				Rails.logger.info("Invalid entry type found (#{value})")
			end
			
			@entrytype = value
			
			@type = case @entrytype
				when 'article' 						then 'An article from a journal or magazine.'
				when 'book' 							then 'A book with an explicit publisher.'
				when 'booklet' 						then 'A work that is printed and bound, but without a named publisher or sponsering institution.'
				when 'conference' 				then 'An article in a conference proceedings.'
				when 'inbook' 						then 'A part of a book.'
				when 'incollection' 			then 'A part of a book having its own title.'
				when 'inproceedings'			then 'An article in a conference proceedings.'
				when 'manual' 						then 'Technical documentation.'
				when 'mastersthesis' 			then 'A Master\'s thesis.'
				when 'misc' 							then ''
				when 'phdthesis' 					then 'A PhD thesis.'
				when 'proceedings' 				then 'The proceedings of a conference.'
				when 'techreport' 				then 'A report published by a school or other institution.'
				when 'unpublished' 				then 'A document having an author and title, but not formally published.'				
			end
			
		end
		
		def month=(value)
			
			value = value.gsub(/\s|\d|[-_\+\.,]/, '')
			
			@month = case value.downcase
				when 'jan' 		then 'January'
				when 'feb' 		then 'February'
				when 'mar' 		then 'March'
				when 'apr' 		then 'April'
				when 'may' 		then 'May'
				when 'jun' 		then 'June'
				when 'jul'		then 'July'
				when 'aug' 		then 'August'
				when 'sep' 		then 'September'
				when 'oct' 		then 'October'
				when 'nov' 		then 'November'
				when 'dec' 		then 'December'
				else value
			end
			
		end
		
		# A setter for tags which makes sure the tags are hashes.
		def tags=(value)
			raise Bibmix::ReferenceError.new("Tags have invalid type (#{value.class}, #{value})") if value.class != Hash
			@tags = value
		end
		
		def address=(value)
			if value != 'pub-ACM:adr'
				@address = value
			end
		end
		
		# Setter for 'author' which makes sure the author is an array.
		def author=(value)
			
			if value.class == String
				value = split_authors(value)
			end
			
			raise Bibmix::ReferenceError.new("Author has an invalid type (#{value.class}, #{value})") if value.class != Array
			@author = value
		end
		
		# Setter for 'pages' which makes sure the number of - is always 1.
		def pages=(value)
			
			if value.kind_of?(String)
				value = value.gsub(/[-]+/,'-')
			end
			
			@pages = value
		end
	
		# Merges the current record with the given record.
		def merge(filtered_reference)
			raise ReferenceInvalidMergeParamError unless filtered_reference.kind_of?(Bibmix::FilteredReference)
			
			reference = filtered_reference.reference
			each_attribute do |attr|
				
				if self.respond_to?("merge_#{attr}")
					self.send("merge_#{attr}", reference)
				elsif self.send(attr).nil? && !reference.send(attr).nil?
					merge_overwrite_attribute(attr, reference)
				end
			end
			
			self
		end
		
#		def merge_pages(record)
#			merge_overwrite_attribute('pages', record)
#		end			
		
		protected	 
		def split_authors(authors)
			result = []
			authors.split(' and ').each do |author|
				result << author
			end
			result
		end
		
		def merge_overwrite_attribute(attr, record)
			if not self.get(attr).eql?(record.get(attr))
				self.send("#{attr}=", record.send(attr))
				self.send("merged=", true)
			end
		end
	end
end