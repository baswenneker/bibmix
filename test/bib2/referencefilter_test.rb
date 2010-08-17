require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class Bib2_ReferenceFilterTest < ActiveSupport::TestCase
  include Bib2
  
  def setup
    @query = Bibsonomy::TitleQuery.new
    @reference = Bib2::Reference.from_hash({
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
 	def test_construction
 		
 		filter = nil
 		assert_nothing_raised{
 			filter = ReferenceFilter.new(@reference, @query)
 		}
 		
 		assert_equal(@reference, filter.base)
 		assert_equal(@query, filter.query)
 		assert_equal(nil, filter.result)
 	end
 
 	# Tests whether the filter actually filters.
 	def test_filter
 		
 		# Execute the query.
 		response = nil
 		assert_nothing_raised{
 			response = @query.execute(@reference.title)
 		}
 		
 		# The query should result in more than one reference. 
 		assert(response.size > 0, 'Query did not find any references.')
 		
 		# Check if the response contains any references which title are equal to the
 		# title of @reference. If so, the filter should result in >0 references after
 		# filtering.
 		found_similar = false
 		@query.response.each do |collected_ref|
 			if collected_ref.title == @reference.title
 				found_similar = true
 			end
 		end
 		
	 	assert(found_similar, 'The query did not find any references with the exact same title, so filter will return no refernces.')

		# Construct the filter and execute the filtering procedure.
 		filter = ReferenceFilter.new(@reference, @query)
 		filter.filter
	 	
	 	assert(filter.result.size > 0)
	 	
	 	filter.result.each do |key, filtered_ref|
	 		# Check the similarity between the filtered reference and @reference.
	 		assert_equal(1, filtered_ref[0])
	 		
	 		# Check if the titles are really equal.
	 		assert_equal(@reference.title, filtered_ref[1].title)
	 	end
	end
 
 	# Tests whether the filter actually filters.
 	def test_filter_year
 		
 		# Execute the query.
 		response = nil
 		assert_nothing_raised{
 			response = @query.execute(@reference.title)
 		}
 		
 		# The query should result in more than one reference. 
 		assert(response.size > 0, 'Query did not find any references.')
 		#puts response.to_yaml
 		
 		# Check if the response contains any references which title are equal to the
 		# title of @reference. If so, the filter should result in >0 references after
 		# filtering.
 		found_similar = false
 		@query.response.each do |collected_ref|
 			if collected_ref.title == @reference.title
 				found_similar = true
 			end
 		end
 		
	 	assert(found_similar, 'The query did not find any references with the exact same title, so filter will return no refernces.')

		# Construct the filter and execute the filtering procedure.
 		filter = ReferenceFilter.new(@reference, @query)
 		filter = FilterDecoratorFactory.instance.year(filter)
 		
 		assert(filter.kind_of?(Bib2::YearFilterDecorator))
 		
 		filter.filter
	 	
	 	assert(filter.result.size > 0)
	 	puts filter.result.size
	 	filter.result.each do |key, filtered_ref|
	 		# Check the similarity between the filtered reference and @reference.
	 		assert_equal(1.0, filtered_ref[0].to_f.round(1))
	 		
	 		# Check if the titles are really equal.
	 		assert_equal(@reference.year, filtered_ref[1].year)
	 	end
	 	
	 	# Reset the similarity values.
	 	filter.reset
	 	
	 	# Filter again, but now with a lower threshold. Use the yearfilterdecorator
	 	# bonus as threshold. This means all collected references with the same
	 	# year as @reference will be part of the filter result 
	 	filter.filter(YearFilterDecorator::SIMILARITY_BONUS)
	 	
	 	filter.result.each do |key, filtered_ref|
	 		assert(filtered_ref[0]>=YearFilterDecorator::SIMILARITY_BONUS)
	 		if filtered_ref[0] < 1
	 			assert(filtered_ref[1].title != @reference.title)
	 			assert(filtered_ref[1].year == @reference.year)
	 		end
	 	end
 	end
  
end
