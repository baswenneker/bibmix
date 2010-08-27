require 'bibmix'

module Bibmix
	class IntelligentReferenceIntegrator
		include ReferenceIntegratorAbstract, DesignByContract
		
		pre(	'Parameter filtered_reference should be a Bibmix::FilteredReference instance or an Array of Bibmix::FilteredReference instances') {|filtered_reference| filtered_reference.is_a?(Bibmix::FilteredReference) || (filtered_reference.is_a?(Array))}
		post(	'Return value should be a Bibmix::AbstractReference instance') {|result, filtered_reference| result.is_a?(Bibmix::AbstractReference)}
		def integrate(filtered_reference)
			
			if filtered_reference.kind_of?(Array)
				filtered_reference = filtered_reference.sort {|x,y| y.relevance <=> x.relevance }
				filtered_reference.each do |ref|
					integrate(ref)
				end				
				integrate_pages(filtered_reference)
			else
				
				#puts filtered_reference.to_yaml
				#puts @target_reference
				if (!@target_reference.booktitle.nil? && !@target_reference.booktitle.empty?) && !filtered_reference.nil? && (!filtered_reference.reference.journal.nil? && !filtered_reference.reference.journal.empty?)
					#puts 'SKIP JOURNAL', @target_reference.to_yaml, filtered_reference.to_yaml
					return @target_reference
				end
				
				if (!@target_reference.journal.nil? && !@target_reference.journal.empty?) && !filtered_reference.nil? && (!filtered_reference.reference.booktitle.nil? && !filtered_reference.reference.booktitle.empty?)
					#puts 'SKIP JOURNAL', @target_reference.to_yaml, filtered_reference.to_yaml
					return @target_reference
				end
					
				Bibmix::log(self, "Integrating #{filtered_reference} with #{@target_reference}")
				
				@target_reference = @target_reference.merge(filtered_reference)
				@target_reference.merged_by << @handler_name if !@handler_name.nil? && !@handler_name.empty? 
			end
			
			@target_reference
		end
		
		def integrate_author(filtered_references)
			
		end
		
		def integrate_pages(filtered_references)
			if !@target_reference.pages.nil? && !@target_reference.pages.empty? && filtered_references.is_a?(Array) && filtered_references.size >= 2
				pages = @target_reference.pages.split('-')
				if pages.size == 2 && pages[0].to_i <= 31 && pages[1].to_i <= 31
					page_index = {}
					filtered_references.each do |f|
						if !f.reference.pages.nil? && !f.reference.pages.empty?
							if !page_index.key?(f.reference.pages)
								page_index[f.reference.pages] = 1 
							else
								page_index[f.reference.pages] += 1
							end
						end
					end
					
					if page_index.size == 1
						@target_reference.pages = page_index.shift[0]
#					elsif page_index.size > 1 && @target_reference.pages.empty?
#						first = page_index.sort {|a,b| a[1]<=>b[1]}.revert.shift
#						@target_reference.pages = first[0]
					end
				end
			end
		end
		
	end
end