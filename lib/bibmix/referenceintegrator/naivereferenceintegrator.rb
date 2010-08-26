require 'bibmix'

module Bibmix
	class NaiveReferenceIntegrator
		include ReferenceIntegratorAbstract, DesignByContract
		
		pre(	'Parameter filtered_reference should be a Bibmix::FilteredReference instance or an Array of Bibmix::FilteredReference instances') {|filtered_reference| filtered_reference.is_a?(Bibmix::FilteredReference) || (filtered_reference.is_a?(Array))}
		post(	'Return value should be a Bibmix::AbstractReference instance') {|result, filtered_reference| result.is_a?(Bibmix::AbstractReference)}
		def integrate(filtered_reference)
			
			if filtered_reference.kind_of?(Array)
				filtered_reference.sort {|x,y| y.relevance <=> x.relevance }
				filtered_reference.each do |ref|
					integrate(ref)
				end				
			else
				Bibmix::log(self, "Integrating #{filtered_reference} with #{@target_reference}")
				
				@target_reference = @target_reference.merge(filtered_reference)
				@target_reference.merged_by << @handler_name if !@handler_name.nil? && !@handler_name.empty? 
			end
			
			@target_reference
		end
		
	end
end