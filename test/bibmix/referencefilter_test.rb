require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class Bibmix_ReferenceFilterTest < ActiveSupport::TestCase
  include Bibmix
  
  def setup
    @query = Bibsonomy::TitleQuery.new
    @reference = Bibmix::Reference.from_hash({
 			:citation => 'Logsonomy - social information retrieval with logdata',
 			:title => 'Logsonomy - social information retrieval with logdata',
 			:year => '2008'
 		})
  end  
  
  def teardown
 		@query = nil
 		@reference = nil
 	end
 	
 	# Tests the ReferenceFilter constructor.
 	def test_constructor
 		
 		filter = nil
 		assert_nothing_raised{
 			filter = ReferenceFilter.new(@reference)
 		}
 		
 		assert_equal(@reference, filter.reference_for_comparison)
 		assert_equal([], filter.collected_references)
 		assert_equal([], filter.filtered_references)
 		
 		assert_raise(Bibmix::Error){
 			filter = ReferenceFilter.new(nil)
 		}
 	end
 
 	# Tests whether the filter actually filters.
 	def test_filter
 		
 		# Execute the query.
 		response = @query.collect_references(@reference)
 		 		
 		# The query should result in more than one reference. 
 		assert(response.size > 0, 'Query did not find any references.')
 		
 		# Check if the response contains any references which title are equal to the
 		# title of @reference. If so, the filter should result in >0 references after
 		# filtering.
 		found_similar = false
 		@query.response.each do |collected_ref|
 			assert(collected_ref.is_a?(Bibmix::CollectedReference))
 			if collected_ref.reference.title == @reference.title
 				found_similar = true
 			end
 		end
 		
	 	assert(found_similar, 'The query did not find any references with the exact same title, so filter will return no refernces.')

		# Construct the filter and execute the filtering procedure.
 		filter = ReferenceFilter.new(@reference)
 		filter.filter(@query.response)
	 	
	 	assert(filter.filtered_references.size > 0)
	 	
	 	filter.filtered_references.each do |filtered_ref|
	 		# Check the similarity between the filtered reference and @reference.
	 		assert_equal(1.0, filtered_ref.relevance)
	 		
	 		# Check if the titles are really equal.
	 		assert_equal(@reference.title, filtered_ref.collected_reference.reference.title)
	 	end
	end
 
 	# Tests whether the filter actually filters.
 	def test_filter_year
 		
 		# Execute the query.
 		response = @query.collect_references(@reference)
 		
 		# The query should result in more than one reference. 
 		assert(response.size > 0, 'Query did not find any references.')
 		
 		
 		# Check if the response contains any references which title are equal to the
 		# title of @reference. If so, the filter should result in >0 references after
 		# filtering.
 		found_similar = false
 		@query.response.each do |collected_ref|
 			assert(collected_ref.is_a?(Bibmix::CollectedReference))
 			if collected_ref.reference.title == @reference.title
 				found_similar = true
 			end
 		end
 		
	 	assert(found_similar, 'The query did not find any references with the exact same title, so filter will return no refernces.')

		# Construct the filter and execute the filtering procedure.
 		filter = ReferenceFilter.new(@reference)
 		filter = FilterDecoratorFactory.instance.year(filter)
 		
 		assert(filter.kind_of?(Bibmix::YearFilterDecorator))
 		
 		filter.filter(@query.response)
	 	
	 	assert(filter.filtered_references.size > 0)
	 	
	 	filter.filtered_references.each do |filtered_ref|
	 		# Check the similarity between the filtered reference and @reference.
	 		assert_equal(1.0, filtered_ref.relevance.round(1))
	 		
	 		# Check if the titles are really equal.
	 		assert_equal(@reference.year, filtered_ref.collected_reference.reference.year)
	 	end
	 	
	 	# Reset the similarity values.
	 	filter.reset
	 	
	 	# Filter again, but now with a lower threshold. Use the yearfilterdecorator
	 	# bonus as threshold. This means all collected references with the same
	 	# year as @reference will be part of the filter result
	 	filter.relevance_threshold = YearFilterDecorator::SIMILARITY_BONUS
	 	filter.filter(@query.response)
	 	
	 	filter.filtered_references.each do |filtered_ref|
	 		assert(filtered_ref.relevance >= YearFilterDecorator::SIMILARITY_BONUS)
	 		if filtered_ref.relevance < 1
	 			assert(filtered_ref.collected_reference.reference.title != @reference.title)
	 			assert(filtered_ref.collected_reference.reference.year == @reference.year)
	 		end
	 	end
 	end
  
end
