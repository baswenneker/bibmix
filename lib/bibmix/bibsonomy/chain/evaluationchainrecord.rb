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
			  #workbook = Spreadsheet::Workbook.new
			  workbook = Spreadsheet.open path
			  # create the heading format
#				heading = Spreadsheet::Format.new({
#					:color => :blue,
#          :weight => :bold,
#					:size => 12
#				})
#				
				co_citation = {:x => 1, :y => 0}
				co_base = 3
				co_title = 5
				co_author = 7
				
			  # create the result worksheet
			  #sheet = workbook.create_worksheet :name => 'Results'
				sheet = workbook.worksheet 'Results'

				sheet[co_citation[:y], co_citation[:x]] = 'test'#base_record.citation
			  
			  # add the results
			  row = 3
			  attr_record.each_attribute do |attr|
				
					#sheet.row(row).set_format(0, heading)

				  #sheet.row(row).push "#{attr}"
				  
				  [
				  	[base_record, co_base], 
				  	[titlequery_record, co_title], 
				  	[authorquery_record, co_author]
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
				# result columns should be wider than evaluation cols
				#[1, 3, 5].each{|no| sheet.column(no).width = 30}
				#[2, 4, 6].each{|no| sheet.column(no).width = 5}
				
				# create the calculations worksheet
#			  sheet = workbook.create_worksheet :name => 'Calculations'
#				
#				sheet.row(0).push('Velden in bibtex entry')
#				
#				
#				sheet.row(0).push("=COUNTA(Results!A3:A27)")
#				
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