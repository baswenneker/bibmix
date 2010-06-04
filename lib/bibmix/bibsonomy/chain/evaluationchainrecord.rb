require 'bibmix/bibsonomy'
require 'fastercsv'
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
				
				if condition == Chain::STATUS_TITLE_MERGED || condition == Chain::STATUS_AUTHOR_MERGED
					@merged = true
				end
				
				@records[condition] = @record.clone
			end
			
			def to_excel(file, path)
				
			  # get all the data.
				parsed_record = get_record Chain::STATUS_NOT_MERGED
			  titlequery_record = get_record(Chain::STATUS_TITLE_MERGED)				
				authorquery_record = get_record(Chain::STATUS_AUTHOR_MERGED)
				attr_record = Bibmix::Bibsonomy::Record.new
				
				# initialize the spreadsheet
			  workbook = Spreadsheet.open path
				
				# set coordinates
				co_date = {:x => 1, :y => 0}
				co_citation = {:x => 1, :y => 1}
				co_merged = {:x => 1, :y => 2}
				
				starting_row = 5
				base_column = 1
				parsed_column = 3
				titlequery_column = 5
				authorquery_column = 7
				
			  # retrieve the result worksheet
				sheet = workbook.worksheet 'Results'

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
				  	[@base_record, base_column, 'y'], 
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
			
				# write the file
			  workbook.write "#{Rails.root}/tmp/evaluation/#{file}.xls"
			  Bibmix.log(self, "wrote evaluation file #{Rails.root}/tmp/evaluation/#{file}.xls")
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
						return previous
					end
					
					previous = @records[value] if !@records[value].nil?
				end		
				
				@record		
			end
		end
	end
end