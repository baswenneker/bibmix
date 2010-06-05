require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		class YearSimilarityDecorator
			include Decorator
			
			SIMILARITY_BONUS = 0.1
			
			def assess_similarity(rec1, rec2)
				
				similarity = @decorated.assess_similarity(rec1, rec2)
				return 1 if similarity >= 1
				
				year_similarity = 0
				if !rec1.year.nil? && !rec2.year.nil?
					if rec1.year.to_i == rec2.year.to_i
						year_similarity = SIMILARITY_BONUS
						Bibmix::log(self, "similar years found for #{rec1} and #{rec2}")
					end
				end
			
				[similarity+year_similarity, 1].min
			end
			
		end
	end
end