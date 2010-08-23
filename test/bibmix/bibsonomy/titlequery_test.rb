require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require File.expand_path(File.dirname(__FILE__) + '/abstractquery_testhelper.rb')

class Bibmix_Bibsonomy_TitleQueryTest < ActiveSupport::TestCase
	include AbstractQueryTest
  
  def setup
  	@query = TitleQuery.new
  	@reference = Bibmix::Reference.from_hash({
 			:title => 'Parscit An open-source CRF reference string parsing package'
 		})
 		@invalid_reference = Bibmix::Reference.from_hash({
 			:title => 'You are never gonna find this one'
 		})
  end
  
 
end
