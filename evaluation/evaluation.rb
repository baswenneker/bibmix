require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

module Evaluation
	include Bibmix::Bibsonomy
	
	def self.init
		
		line_no = 0
		File.open("#{File.dirname(__FILE__)}/tagged_references.txt") {|f| 
			
			line_no = 1
			while line = f.readline do 
				base = get_token_hash_from_annotated_citation(line)
							
				title = TitleQueryChain.new(Chain::STATUS_NOT_MERGED)
	 			author = title.chain(AuthorQueryChain.new(Chain::STATUS_TITLE_NOT_MERGED))
	 			
	 			hash = Reference.create_with_parscit(base['citation']).to_hash
				puts hash.to_yaml
				
				record = Record.from_hash(hash)
	 			
	 			chainrecord = EvaluationChainRecord.new(record)
	 			chainrecord.base_record = Record.from_hash(base)
	 			chainrecord = title.execute(chainrecord)
	 			
	 			chainrecord.to_excel("citation-#{line_no}","#{File.dirname(__FILE__)}/template.xls")
	 			
	 			if line_no == 10
	 				exit
	 			end
	 			line_no += 1
	 		end
		}
	end
	
	def self.get_token_hash_from_annotated_citation(cstr)
		puts cstr
		tokens_and_tags = cstr.split(/\s+/)
		
		type = []
		hash = {}
		tag = ''
		tokens_and_tags.each_with_index do |tok, i|
    	
			if tok =~ /^<([a-z]+)>$/
				tag = $1
				next
			elsif tok =~ /^<\/([a-z]+)>$/
				hash[$1] = type.join(' ')
				tok =  nil
				type = []
				next
      end
			
			type.push(tok)
		end
		hash['citation'] = cstr.gsub(/\s*<[^>]*>\s*/, ' ')
		
		hash
	end
end

Evaluation.init