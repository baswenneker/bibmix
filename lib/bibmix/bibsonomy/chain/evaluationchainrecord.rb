require 'bibmix/bibsonomy'
require 'fastercsv'
require "spreadsheet" 

module Bibmix
	module Bibsonomy
		class EvaluationChainRecord < ChainRecord
			
			attr_reader :records
			
			def initialize(record=nil)
				@records = {}
				super(record)
			end
			
			def condition=(condition)
				@condition = condition
				
				@records[condition] = @record.clone
			end
			
			def to_csv
				
#				puts 'start'
#				titlequery_time = Benchmark.realtime do
#				  run_titlequery_step
#				end
#				puts titlequery_time
				
				titlequery_result = get_record(Chain::STATUS_TITLE_MERGED)
				
#				authorquery_time = Benchmark.realtime do
#					run_authorquery_step
#				end
				authorquery_result = get_record(Chain::STATUS_AUTHOR_MERGED)
#				puts authorquery_time

				tmp_record = Bibmix::Bibsonomy::Record.new
				record = get_record(Chain::STATUS_NOT_MERGED)
				
				#puts @record.to_yaml,'#####'
				
				fields = ['fields', 'base', "title_query", "author_query"]
				csv_buffer = ''
				csv_buffer << FasterCSV.generate do |csv|
				  csv << [record.citation]
				  csv << fields
				  
				  tmp_record.each_attribute do |attr|
				  	
				  	row = []
				  	row << attr
				  	row << record.get(attr, '')
				  	puts record.get(attr, '')
				  	if not titlequery_result.nil?
				  		row << titlequery_result.get(attr, '')
				  	else
				  		row << ''
				  	end
				  	
				  	if not authorquery_result.nil?
				  		row << authorquery_result.get(attr, '')
				  	else
				  		row << ''
				  	end
				  	
				  	csv << row
				 	end
				 
				end
				
				File.open("#{Rails.root}/tmp/test.csv", 'w') {|f| f.write(csv_buffer) }
			end
			
			def to_excel(path)
				
			  # get all the data.
			  base_record = get_record(Chain::STATUS_NOT_MERGED)
			  titlequery_record = get_record(Chain::STATUS_TITLE_MERGED)				
				authorquery_record = get_record(Chain::STATUS_AUTHOR_MERGED)
				attr_record = Bibmix::Bibsonomy::Record.new
				
				# initialize the spreadsheet
			  workbook = Spreadsheet.open path
				
				# set coordinates
				co_date = {:x => 1, :y => 0}
				co_citation = {:x => 1, :y => 1}
				
				starting_row = 4
				base_column = 3
				titlequery_column = 5
				authorquery_column = 7
				
			  # retrieve the result worksheet
				sheet = workbook.worksheet 'Results'

				# set the citation cell
				sheet[co_date[:y], co_date[:x]] = Time.now().strftime('%d/%m/%y %H:%M')

				# set the citation cell
				sheet[co_citation[:y], co_citation[:x]] = base_record.citation
			  
			  # add the results
			  row = starting_row
			  attr_record.each_attribute do |attr|
				
				  [
				  	[base_record, base_column], 
				  	[titlequery_record, titlequery_column], 
				  	[authorquery_record, authorquery_column]
				  ].each do |record, co|
				  	
				  	value = record.get(attr, '')
				  	sheet[row, co] = value
				  	if value == ''
				  		sheet[row, co+1] = ''
				  	else
				  		sheet[row, co+1] = 'yn'
				  	end
				  end
				  
			  	row += 1
			 	end
				sheet.updated_from(0)
			
				# write the file
			  workbook.write "#{Rails.root}/tmp/test.xls"
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