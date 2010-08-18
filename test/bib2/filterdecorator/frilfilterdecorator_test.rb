require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require File.expand_path(File.dirname(__FILE__) + '/abstractfilterdecorator_testhelper.rb')

class Bib2_FrilFilterDecoratorTest < ActiveSupport::TestCase
  include AbstractFilterDecorator
  
  def setup
    @query = Bibsonomy::TitleQuery.new
    @reference = Bib2::Reference.from_hash({
 			:title => 'Logsonomy - social information retrieval with logdata',
 			:year => '2008'
 		})
 		@collected_references = [
 			Bib2::CollectedReference.new(Bib2::Reference.from_hash({
	 			:title => 'Logsonomy - social information retrieval with logdata',
	 			:series => 'series1',
	 			:year => '2008',
	 			:intrahash => 'id1'
	 		}), 'unknown source'),
	 		Bib2::CollectedReference.new(Bib2::Reference.from_hash({
	 			:title => 'test2',
	 			:series => 'series2',
	 			:year => '2007',
	 			:intrahash => 'id2'
	 		}), 'unknown source'),
 		]
 		@filter_decorator_class = Bib2::FrilFilterDecorator
  end  
  
 	# Tests whether the filter actually filters.
 	def test_filter_bonus
 		
 		filter = ReferenceFilter.new(@reference)
 		filter = @filter_decorator_class.new(filter)
 		
 		filtered_references = filter.filter(@collected_references)
 		
 		assert(filtered_references.is_a?(Array))
 		assert(filtered_references.inject(true){|is_a,item| is_a && item.is_a?(Bib2::FilteredReference) })
 		
 		filtered_references.each do |filtered_ref|
 			if filtered_ref.reference.id == 'id1'
 				assert(filtered_ref.relevance > 0)
 			else
 				assert_equal(0, filtered_ref.relevance)
 				assert_equal('id2', filtered_ref.reference.id)
 			end
 		end
 	end
end

#require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')
#
#class Bibsonomy_FrilFilterDecoratorTest < ActiveSupport::TestCase
#  include Bib2
#   
#	# Tests whether the bonus is added when the years are equal in both records.
# 	def test_merging
# 		
# 		# set up records
# 		record = Reference.from_hash({
# 			:title => 'A model for hierarchical memory',
# 			:citation => 'A. Aggarwal, B. Alpern, A. K. Chandra, and M. Snil. A model for hierarchical memory. In Proceedings of the Nineteenth Annual ACM Symposium on Theory of Computing, pages 305-313, 1987.'
# 		}) 
# 		
# 		query = Bibsonomy::TitleQuery.new(record.title)
# 		
# 		merged_record = FilterDecoratorFactory.instance.fril(Bib2::RecordLinker.new(record, query)).merge
# 		
# 	end
# 	
#end