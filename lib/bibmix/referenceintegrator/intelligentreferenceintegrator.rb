require 'bibmix'

module Bibmix
	class IntelligentReferenceIntegrator
		include ReferenceIntegratorAbstract, DesignByContract
		
		pre(	'Parameter filtered_reference should be a Bibmix::FilteredReference instance or an Array of Bibmix::FilteredReference instances') {|filtered_reference| filtered_reference.is_a?(Bibmix::FilteredReference) || (filtered_reference.is_a?(Array))}
		post(	'Return value should be a Bibmix::AbstractReference instance') {|result, filtered_reference| result.is_a?(Bibmix::AbstractReference)}
		def integrate(filtered_reference)
			
			if filtered_reference.kind_of?(Array)
				filtered_reference.each do |ref|
					integrate(ref)
					integrate_pages
				end				
			else
				Bibmix::log(self, "Integrating #{filtered_reference} with #{@target_reference}")
				
				@target_reference = @target_reference.merge(filtered_reference)
				@target_reference.merged_by << @handler_name if !@handler_name.nil? && !@handler_name.empty? 
			end
			
			@target_reference
		end
		
		def integrate_author(filtered_references)
			
		end
		
		def integrate_pages(filtered_references)
			if !@target_reference.pages.empty? && filtered_references.size >= 2
				pages = @target_reference.pages.split('-')
				if pages.max <= 31
					page_index = {}
					filtered_references.each do |f|
						if !f.page.emtpy?
							if !page_index.key?(f.page)
								page_index[f.page] = 1 
							else
								page_index[f.page] += 1
							end
						end
					end
					
					if page_index.size == 1
						@target_reference.pages = page_index.shift[0]
					end
				end
			end
		end
		
	end
end