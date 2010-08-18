require 'bib2'

module Bib2
	class YearFilterDecorator
		include Decorator, DesignByContract
		
		SIMILARITY_BONUS = 0.1
		
		pre(	'Property @relevance_threshold should be false or a Float') { (@decorated.relevance_threshold === nil) || @decorated.relevance_threshold.is_a?(Float) }
		pre(	'Parameter collected_references should be an Array of Bib2::CollectedReference instances') { |collected_references| collected_references.is_a?(Array) && collected_references.inject(true){|is_a,item| is_a && item.is_a?(Bib2::CollectedReference) } }
		post(	'Return value should be an Array of Bib2::FilteredReference instances') { @decorated.filtered_references.is_a?(Array) && @decorated.filtered_references.inject(true){|is_a,item| is_a && item.is_a?(Bib2::FilteredReference) } }
		def filter(collected_references)
			
			collected_references.each do |collected_ref|
				@decorated.similarity_lookup_hash[collected_ref.reference.id] = compute_relevance_of_references(@decorated.reference_for_comparison, collected_ref.reference)
			end
			
			@decorated.filter(collected_references)
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