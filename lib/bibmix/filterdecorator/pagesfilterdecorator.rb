require 'bibmix'

module Bibmix
	class PagesFilterDecorator
		include Decorator
					
		SIMILARITY_BONUS = 0.3
		SIMILARITY_PENALTY = -0.2
					
		def assess_similarity(rec1, rec2)
			
			similarity = @decorated.assess_similarity(rec1, rec2)
			return 1 if similarity >= 1
			
			# asses similarity of the pagenumbers in the records
			page_similarity = 0
			
			if !rec1.pages.nil? && !rec2.pages.nil?
				if rec1.pages.split(/-+/) == rec2.pages.split(/-+/)
					page_similarity = SIMILARITY_BONUS
					Bibmix::log(self, "similar pages found for #{rec1} and #{rec2} (#{rec1.pages} == #{rec2.pages})")
				else
					page_similarity = SIMILARITY_PENALTY
					Bibmix::log(self, "different pages found for #{rec1} and #{rec2} (#{rec1.pages} == #{rec2.pages})")
				end
			end
				
			# return the sum of similarities, with a max of 1 and a min of 0
			[0,[similarity + page_similarity, 1].min].max
		end
		
	end
end
