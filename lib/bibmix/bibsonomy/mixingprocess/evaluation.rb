require 'bibmix/bibsonomy'
require 'fastercsv'

module Bibmix
	module Bibsonomy
		module Mixingprocess	
			class Evaluation < Bibmix::Bibsonomy::MixingProcess
				
				@csv_string = nil
				
				def execute
					@csv_string = ''
					execute_tq_aq
				end
				
				def execute_tq_aq
					puts 'start'
					titlequery_time = Benchmark.realtime do
					  run_titlequery_step
					end
					puts titlequery_time
					
					titlequery_result = @result.clone
					
					authorquery_time = Benchmark.realtime do
						run_authorquery_step
					end
					authorquery_result = @result.clone
					puts authorquery_time
					
					
					tmp_record = Bibmix::Record.new
					fields = ['fields', 'base', "title_query(#{titlequery_time})", "author_query(#{authorquery_time})"]
					@csv_string << FasterCSV.generate do |csv|
					  csv << [@base.citation]
					  csv << fields
					  tmp_record.each_attribute do |attr|
					  	row = []
					  	row << attr
					  	row << @base.fetch(attr, '')
					  	
					  	if not titlequery_result.nil?
					  		row << titlequery_result.fetch(attr, '')
					  	else
					  		row << ''
					  	end
					  	
					  	if not authorquery_result.nil?
					  		row << authorquery_result.fetch(attr, '')
					  	else
					  		row << ''
					  	end
					  	
					  	csv << row
					 	end
					 
					end
					
					File.open("#{Rails.root}/tmp/test.csv", 'w') {|f| f.write(@csv_string) }
				end
				
			end
		end
	end
end