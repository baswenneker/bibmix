module Bibmix
	module Bibsonomy
			
		class Tokenizer
			
			def self.tokenize(str)
				tokens = str.split(/[^a-zA-Z0-9 ]/)
				
				if tokens.kind_of?(String)
					tokens = [tokens]
				end
				
				tokens.reject{|s| s =~ /^\s*$/}.map{|s| s.strip}
			end
			
		end
	end
end