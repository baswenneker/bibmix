require 'bib2'

module Bib2
	class YearFilterDecorator
		include Decorator
		
		SIMILARITY_BONUS = 0.1
		
		def filter
			
			collected_references = @decorated.collected_references
			
			collected_references.each do |collected_ref|
				@decorated.similarity_lookup_hash[collected_ref.reference.id] = compute_relevance_of_references(@decorated.reference_for_comparison, collected_ref.reference)
			end
			
			@decorated.filter
		end
		
		def compute_relevance_of_references(rec1, rec2)
			
			similarity = @decorated.compute_relevance_of_references(rec1, rec2)
			return 1.0 if similarity >= 1.0
			
			year_similarity = 0.0
			if !rec1.year.nil? && !rec2.year.nil?
				if rec1.year.to_i == rec2.year.to_i
					year_similarity = SIMILARITY_BONUS
					Bib2::log(self, "similar years found for #{rec1} and #{rec2}")
				end
			end
		
			[similarity+year_similarity, 1.0].min
		end
		
	end
end