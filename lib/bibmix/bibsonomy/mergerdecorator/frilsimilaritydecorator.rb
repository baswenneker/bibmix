require 'bibmix/bibsonomy'
require 'spreadsheet'
require 'faster_csv'
require "rexml/document"

module Bibmix
	module Bibsonomy
		class FrilSimilarityDecorator
			include Decorator
				
			attr_accessor :fril_matching
						
			def merge(*args)				
				
				write_spreadsheets
				execute_fril
				read_matching_result
								
				@decorated.merge(*args)
			end
			
			protected
			def execute_fril
				
				config = YAML.load_file("#{Bibmix::CONFIG_DIR}/fril/fril_config.yml")['default']
				
#				file = "#{Bibmix::CONFIG_DIR}/fril/fril_match_config.xml"
#				text = File.read(file) 
#  			File.open("#{Rails.root}/tmp/fril/config.xml", 'w+') do |f| 
#  				 text = text.gsub(/__source_a__/,	"#{Rails.root}/tmp/fril/query.xls")
#  				 text = text.gsub(/__source_b__/,	"#{Rails.root}/tmp/fril/response.xls")
#  				 text = text.gsub(/__output_result__/,	"#{Rails.root}/tmp/fril/result.csv")
#  				 f << text
#  			end
  			
  			prepare_xml_config
  			
  			text = File.read("#{Bibmix::CONFIG_DIR}/fril/fril.sh")
  			text = text.gsub(/__fril_directory__/, config['fril_path'])
  			text = text.gsub(/__config_file__/, "#{Rails.root}/tmp/fril/config.xml")
  			
  			`#{text}`  			
  			
			end
			
			def read_matching_result
				
				attrs = Bibmix::Bibsonomy::Record.new.get_attributes
				@fril_matching = {}	
					
				skip_row = true
				FasterCSV.foreach("#{Rails.root}/tmp/fril/result.csv") do |row|
					
					if skip_row
						skip_row = false
						next
					end
										
					hash = {}
					row.each_with_index do |val, key| 
					  hash[attrs[key]] = val
					end
					
					new_record = Bibmix::Bibsonomy::Record.from_hash(hash)
					#puts new_record.to_yaml
					#@fril_matching[new_record.id] = [new_record, row.last]
					@decorated.similarity_lookup_hash[new_record.id] = row.last.to_i/100
				end
			end
			
			def prepare_xml_config
				
				file = File.new("#{Bibmix::CONFIG_DIR}/fril/fril_match_config.xml")
				document = REXML::Document.new(file)
			
				els = document.root.elements
				
				els['left-data-source/params/param[@name="file-name"]'].attributes['value'] = "#{Rails.root}/tmp/fril/query.xls"
				els['right-data-source/params/param[@name="file-name"]'].attributes['value'] = "#{Rails.root}/tmp/fril/response.xls"
				els['results-savers/results-saver/params/param[@name="output-file"]'].attributes['value'] = "#{Rails.root}/tmp/fril/result.csv"
				
				document.write("#{Rails.root}/tmp/fril/config.xml")
			end
			
			def write_spreadsheets
				
				querybook = Spreadsheet::Workbook.new
				sheet = querybook.create_worksheet
				
				header = []
				@decorated.base.each_attribute do |attr|
					header << attr.to_s
				end
				sheet.row(0).concat(header)
				sheet.row(1).concat(@decorated.base.to_array)
				
				querybook.write "#{Rails.root}/tmp/fril/query.xls"
				
				query = @decorated.query;
				response_array = []
				if query.kind_of?(Bibmix::Query)
					if query.response.kind_of?(Array)						
						query.each do |q|
							response_array << q.response
						end
					else
						response_array = query.response
					end
				end
			
				responsebook = Spreadsheet::Workbook.new
				sheet = responsebook.create_worksheet
				
				sheet.row(0).concat(header)
				row = 1
				response_array.each do |record|
					sheet.row(row).concat(record.to_array)
					row += 1
				end
				responsebook.write "#{Rails.root}/tmp/fril/response.xls"
			end
			
			
		end
	end
end


			