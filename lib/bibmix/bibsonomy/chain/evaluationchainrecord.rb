require 'bibmix/bibsonomy'
require "spreadsheet" 

module Bibmix
	module Bibsonomy
		class EvaluationChainRecord < ChainRecord
			
			attr_reader :records, :merged
			attr_accessor :base_record
			
			def initialize(record=nil)
				@records = {}
				@merged = false
				super(record)
			end
			
			def condition=(condition)
				@condition = condition
								
				@records[condition] = @record.clone
				@merged |= record.merged
				@record.merged = false
			end
			
			def to_excel(file, template_file)
				
			  # get all the data.
				parsed_record = get_record(Chain::STATUS_NOT_MERGED)
			  titlequery_record = get_record(Chain::STATUS_TITLE_MERGED)				
				authorquery_record = get_record(Chain::STATUS_AUTHOR_MERGED)
				attr_record = Bibmix::Bibsonomy::Record.new
				
				# initialize the spreadsheet
			  workbook = Spreadsheet.open(template_file)
				
				# set coordinates
				co_date = {:x => 1, :y => 0}
				co_citation = {:x => 1, :y => 1}
				co_merged = {:x => 1, :y => 2}
				
				starting_row = 5
				#base_column = 1
				parsed_column = 2
				titlequery_column = 4
				authorquery_column = 6
				
				# retrieve the result worksheet
				sheet = workbook.worksheet 'Expert'
				# set the citation cell
				sheet[co_citation[:y], co_citation[:x]] = parsed_record.citation
				
			  # retrieve the result worksheet
				sheet = workbook.worksheet 'Bibmix'

				# set the citation cell
				sheet[co_date[:y], co_date[:x]] = Time.now().strftime('%d/%m/%y %H:%M')

				# set the citation cell
				sheet[co_citation[:y], co_citation[:x]] = parsed_record.citation
				
				# set the citation cell
				sheet[co_merged[:y], co_merged[:x]] = self.merged ? 'Yes, extra information was found and merged.' : 'No information found.'
			  
			  default_evaluation_value = self.merged ? 'yn' : 'y'
			  
			  # add the results
			  row = starting_row
			  attr_record.each_attribute do |attr|
				
				  [
				  	#[@base_record, base_column, 'y'], 
				  	[parsed_record, parsed_column, default_evaluation_value], 
				  	[titlequery_record, titlequery_column, default_evaluation_value], 
				  	[authorquery_record, authorquery_column, default_evaluation_value]
				  ].each do |record, column, default|
				  	
				  	value = record.get(attr, '')
				  	
				  	if value.is_a? Array
				  		value = value.join(', ')
				  	end
				  	
				  	sheet[row, column] = value
				  	if value == ''
				  		sheet[row, column+1] = ''
				  	else
				  		sheet[row, column+1] = default
				  	end
				  	
				  end
				  
			  	row += 1
			 	end
				sheet.updated_from(0)
			
				filepath = "#{Bibmix.get_config('tmp_dir')}/#{file}.xls"
				if File.exist?(filepath)
					File.delete(filepath)
				end
			
				# write the file
			  workbook.write(filepath)
			  Bibmix.log(self, "wrote evaluation file #{filepath}")
			end
			
			protected
			# Method which returns the record 
			def get_record(status)
				
				# return the record when it is present
				return @records[status] if not @records[status].nil?
				
				# set the default return record
				previous = @record	
				
				# loop over [value, const_name] pairs
				Chain.status_hash.invert.sort.each do |value, const_name|
				
					if value == status
						# this is just a copy of a preceding record, so it is not merged
						previous.merged = false
						
						# return the record
						return previous
					end
					
					previous = @records[value] if !@records[value].nil?
				end		
				
				@record		
			end
		end
	end
end