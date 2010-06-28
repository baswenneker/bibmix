require File.expand_path(File.dirname(__FILE__) + "/../../../../../config/environment")
require 'csv'

module TestSetWriter
	include Bibmix::Bibsonomy
	
	def self.init
		
		query_csv = CSV.open("#{File.dirname(__FILE__)}/queries.csv", 'wb')
	  response_csv = CSV.open("#{File.dirname(__FILE__)}/responses.csv", 'wb')
		
		query_csv << Record.new.get_attributes
		response_csv << Record.new.get_attributes
		
		File.open("#{File.dirname(__FILE__)}/flux-cim-cs.txt", 'r') {|f| 
			
			begin
				while line = f.readline do 
					
					hash = Reference.create_with_parscit(line).to_hash
					record = Record.from_hash(hash)
					
					query_csv = self.write_record_to_csv(query_csv, record)
					
					query = Bibmix::Bibsonomy::TitleQuery.new(record.title)
					query.response.each do |r|							
						response_csv = self.write_record_to_csv(response_csv, r)
					end		
					
					record.author.each do |q|
						
						# Query on author name.
						query = Bibmix::Bibsonomy::AuthorQuery.new(q)
						
						query.response.each do |r|							
							response_csv = self.write_record_to_csv(response_csv, r)
						end						
					end
					
				end
			rescue EOFError
			  f.close
			end
		}
		
		query_csv.close
		response_csv.close
	end
	
	def self.write_record_to_csv(csv, record)
		row = []
		
		record.each_attribute do |val|
			val = record.get(val, ' ')
			
			if !val.nil? && val.kind_of?(Array)
				val = val.join(' and ')
			end
			row << val
		end
		csv << row
		csv
	end
end

TestSetWriter.init