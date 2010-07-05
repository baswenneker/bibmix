require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bibsonomy_FrilSimilarityDecoratorTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
   
	# Tests whether the bonus is added when the years are equal in both records.
 	def test_merging
 		
 		# set up records
 		record = Record.from_hash({
 			:title => 'A model for hierarchical memory',
 			:citation => 'A. Aggarwal, B. Alpern, A. K. Chandra, and M. Snil. A model for hierarchical memory. In Proceedings of the Nineteenth Annual ACM Symposium on Theory of Computing, pages 305-313, 1987.'
 		}) 
 		
 		query = TitleQuery.new(record.title)
 		
 		merged_record = MergerDecoratorFactory.instance.fril(Bibmix::RecordMerger.new(record, query)).merge
 		
 	end
 	
end