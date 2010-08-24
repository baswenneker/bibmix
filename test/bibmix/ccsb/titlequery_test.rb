require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require File.expand_path(File.dirname(__FILE__) + '/../abstract/query.rb')

class Bibmix_Ccsb_TitleQueryTest < ActiveSupport::TestCase
	include Bibmix::Ccsb, Bibmix_Abstract_QueryTest
  
  def setup
  	@query = Bibmix::Ccsb::TitleQuery.new
  	@reference = Bibmix::Reference.from_hash({
 			:title => 'Parscit An open-source CRF reference string parsing package'
 		})
 		@invalid_reference = Bibmix::Reference.from_hash({
 			:title => '_______'
 		})
  end
  
end
