require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		class TitleSimilarityDecorator
			include Decorator
						
			def assess_similarity(rec1, rec2)
				
				similarity = @decorated.assess_similarity(rec1, rec2)
				return 1 if similarity >= 1
				
				# asses string similarity of the title using pair distance similarity measure
				title_similarity = 0
				if !rec1.title.nil? && !rec2.title.nil?
					title_similarity = rec1.title.pair_distance_similar(rec2.title)
				end
					
				# return the sum of similarities, with a max of 1
				[similarity + title_similarity, 1].min
			end
			
		end
	end
end
