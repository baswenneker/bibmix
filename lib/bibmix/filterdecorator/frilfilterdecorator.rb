require 'bibmix'
require 'spreadsheet'
require 'faster_csv'
require 'rexml/document'

module Bibmix
	class FrilFilterDecorator
		include Decorator, DesignByContract
			
		@random_id = nil
		@temp_querybook_file = nil
		@temp_responsebook_file = nil
		@temp_fril_config_file = nil
		
		attr_accessor :fril_matching
		
		pre(	'Property @relevance_threshold should be false or a Float') { (@decorated.relevance_threshold === nil) || @decorated.relevance_threshold.is_a?(Float) }
		pre(	'Parameter collected_references should be an Array of Bibmix::CollectedReference instances') { |collected_references| collected_references.is_a?(Array) && collected_references.inject(true){|is_a,item| is_a && item.is_a?(Bibmix::CollectedReference) } }
		post(	'Return value should be an Array of Bibmix::FilteredReference instances') { @decorated.filtered_references.is_a?(Array) && @decorated.filtered_references.inject(true){|is_a,item| is_a && item.is_a?(Bibmix::FilteredReference) } }
		def filter(collected_references)		
			
			# Generate a random id to be used in filenames.
			@random_id = rand
			
			# Write the query and response spreadsheets.
			write_spreadsheets(collected_references)
			
			# Writes a temporary configuration file to be used by fril.
			prepare_xml_config
			
			# Performs matching algorithms determining the similarity of records in
			# the response book compared to the record in the query book.
			execute_fril
			
			# Reads the result of the matching proces.
			read_matching_result
			
			# Clean up the temporary files.
			cleanup				
			
			@decorated.filter(collected_references)
		end
		
		protected
		
		# Performs matching algorithms determining the similarity of records in
		# the response book compared to the record in the query book.
		# The result of this similarity matching (along with a confidence level) is
		# stored in a temporary file.
		def execute_fril
			  	
			# Read the template executable.
			text = File.read(Bibmix.get_config('fril_template_executable'))
			
			# Replace certain values to point to the right FRIL executable directory
			# and config file.
			text = text.gsub(/__fril_directory__/, Bibmix.get_config('fril_executable_dir'))
			text = text.gsub(/__config_file__/, @temp_fril_config_file)
			
			# Execute FRIL.
			`#{text}`
		end
		
		# Reads the result of the matching proces.
		def read_matching_result
			
			# Get an array of attributes.
			attrs = Bibmix::Reference.new.get_attributes					
			skip_row = true
					
			FasterCSV.foreach(@temp_resultbook_file) do |row|
				
				if skip_row
					# Skip the first row, it contains a header.
					skip_row = false
					next
				end
				
				# Read the values in the current row and store the values in a hash.
				hash = {}
				row.each_with_index do |val, key| 
				  hash[attrs[key]] = val
				end
				
				# Convert the hash to a record.
				new_record = Bibmix::Reference.from_hash(hash)
				
				# 
				@decorated.similarity_lookup_hash[new_record.id] = row.last.to_i/100
			end
		end
		
		# Writes a temporary configuration file to be used by fril.
		def prepare_xml_config
			
			file = File.new(Bibmix.get_config('fril_template_config'))
			document = REXML::Document.new(file)
		
			els = document.root.elements
			
			@temp_resultbook_file = "#{Bibmix.get_config('fril_tmp_dir')}/result#{@random_id}.csv";
			els['left-data-source/params/param[@name="file-name"]'].attributes['value'] = @temp_querybook_file
			els['right-data-source/params/param[@name="file-name"]'].attributes['value'] = @temp_responsebook_file
			els['results-savers/results-saver/params/param[@name="output-file"]'].attributes['value'] = @temp_resultbook_file 
			
			@temp_fril_config_file = "#{Bibmix.get_config('fril_tmp_dir')}/config#{@random_id}.xml"
			File.open(@temp_fril_config_file, 'w') {|f| f.write(document) }
		end
		
		# This method writes two spreadsheets. 
		#
		# The first spreadsheet (query book) contains columns filled with the 
		# record for which additional information is queried. 
		# The second spreadheet (response book) contains rows and columns filled 
		# with records which where the response of the query.
		#
		# Fril will check if any of the rows in the response book correspond to
		# the record in the query book. 
		def write_spreadsheets(collected_references)
			
			querybook = Spreadsheet::Workbook.new
			querysheet = querybook.create_worksheet
			
			# Assemble an array with names used for the headers in both books.
			header = []
			@decorated.reference_for_comparison.each_attribute do |attr|
				header << attr.to_s
			end
			
			# Write the header.
			querysheet.row(0).concat(header)
			# Write the query record in the query book.
			querysheet.row(1).concat(@decorated.reference_for_comparison.to_array)
			
			# Write the query book to a temporary file.
			@temp_querybook_file = "#{Bibmix.get_config('fril_tmp_dir')}/query#{@random_id}.xls"
			querybook.write @temp_querybook_file
			
			# Retrieve an array of records that where in the query response.
			#collected_references = @decorated.collected_references
#			query = @decorated.query;
#			response_array = []
#			if query.kind_of?(Bibmix::AbstractReferenceCollector)
#				if query.response.kind_of?(Array)						
#					query.each do |q|
#						response_array << q.response
#					end
#				else
#					response_array = query.response
#				end
#			elsif query.kind_of?(Array)
#				query.each do |subquery|
#					if subquery.response.kind_of?(Array)						
#						subquery.each do |q|
#							response_array << q.response
#						end
#					else
#						response_array = subquery.response
#					end
#				end
#			end
			
			
			responsebook = Spreadsheet::Workbook.new
			responsesheet = responsebook.create_worksheet
			
			# Write the header.
			responsesheet.row(0).concat(header)
			
			# Write the response records into the response book.
			row = 1
			collected_references.each do |collected_ref|
				responsesheet.row(row).concat(collected_ref.reference.to_array)
				row += 1
			end
			
			# Write the response book to a temporary file.
			@temp_responsebook_file = "#{Bibmix.get_config('fril_tmp_dir')}/response#{@random_id}.xls"
			responsebook.write @temp_responsebook_file
		end
		
		# Cleans up temporary files.
		def cleanup
#			File.delete(@temp_querybook_file) if File.exists?(@temp_responsebook_file)
#			File.delete(@temp_responsebook_file) if File.exists?(@temp_responsebook_file)
#			File.delete(@temp_fril_config_file) if File.exists?(@temp_fril_config_file)
#			File.delete(@temp_resultbook_file) if File.exists?(@temp_resultbook_file)				
		end
	end
end


			