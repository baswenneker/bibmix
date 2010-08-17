require "test/unit"
require "rubygems"
require "bibtex"
require "csv"
require "json"
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ImportTest < ActiveSupport::TestCase
	include Bibmix::Bibsonomy
	
	def do_not_run_test_import
		
	  csv = CSV.open("#{File.dirname(__FILE__)}/hidders.csv", 'wb')
	  
	  attrs = Record.new.get_attributes
	  csv << attrs
	  
		Bibtex::Parser.parse("#{File.dirname(__FILE__)}/text.bib").map do |entry|
	    #csv << entry
	    row = []
	    row.fill('',0..attrs.size-1)
	    attrs.each_with_index do |attr, index|
	    	
	    	begin
	    		row[index] = entry[attr.to_s.capitalize.to_sym]
	    	rescue RuntimeError => e	    		
	    	end
	    
	    end
	    csv << row
	    entry
	  end
	  
	  csv.close
	end
	
	def no_test_import_houben
		
		csv = CSV.open("#{File.dirname(__FILE__)}/houben.csv", 'wb')
	  
	  attrs = Record.new.get_attributes
	  csv << attrs
	  
	  json = IO.readlines("#{File.dirname(__FILE__)}/pipe-4.run",'').to_s
	  
		result = JSON.parse(json)
	  result['value']['items'].each do |parsed|
	  	
	  	author = parsed['author'].gsub(/^\s*/,'').gsub(/\s*$/,'')
	  	title = parsed['title'].gsub(/<.*?>\s*/,'')
	  	title = title.gsub(/&/, 'and')
	  	title = title.gsub(/^\s*|\s*$/,'')
	  	other = parsed['other'].gsub(/^\s*in\s*:\s*/, '')
	  	other = other.gsub(/<.*?>/,'')
	  	
	  	citation = "#{author}. \"#{title}\". #{other}"
	  	puts citation
			ref = Reference.create_with_parscit(citation)
			
			record = Record.from_hash(ref.to_hash)
			csv << record.to_array
	  end
	  
	  csv.close
		
	end
	
end