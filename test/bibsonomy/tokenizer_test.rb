require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibsonomy_TokenizerTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
   
 	def test_tokenizer_separators
 		separators = ['.', '"', "'", '-', ':', '(', ')']
 		separators.each do |s|
 			str = "test#{s}test"
	 		
	 		tokens = Tokenizer.tokenize(str)
	 		
	 		assert_equal 2, tokens.size
	 		assert_equal 'test', tokens[0]
	 		assert_equal 'test', tokens[1]
 		end 		
 	end
 
 	def test_tokenize_citation
 		
	 	str = "author, a. 'My title', publisher etc"
	 	tokens = Tokenizer.tokenize(str)
	 	
	 	assert_equal 4, tokens.size
	 	assert_equal 'author', tokens[0]
	 	assert_equal 'a', tokens[1]
	 	assert_equal 'My title', tokens[2]
	 	assert_equal 'publisher etc', tokens[3]
 				
 	end

end
