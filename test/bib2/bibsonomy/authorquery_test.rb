require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require File.expand_path(File.dirname(__FILE__) + '/abstractquery_testhelper.rb')

class Bib2_Bibsonomy_AuthorQueryTest < ActiveSupport::TestCase
	include AbstractQueryTest
  
	def setup
    @query = Bib2::Bibsonomy::AuthorQuery.new
    @reference = Bib2::Reference.from_hash({
 			:author => ['houben', 'Geert-Jan Houben', 'Houben, G.J.']
 		})
 		@invalid_reference = Bib2::Reference.from_hash({
 			:author => ['__invalid__AUTHOR__']
 		}) 		
  end
  
end