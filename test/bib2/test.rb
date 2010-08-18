require File.expand_path(File.dirname(__FILE__) + '/test_helper')

module Bib2
	module EnrichmentHandlerInterface2
		include DesignByContract
		
		@@input_reference = nil
		
		#def initialize(reference)
		#	raise Bib2::NotImplementedError
		#end
		
		
	end
end

module Bib2
	module EnrichmentHandlerAbstract2
		
		@input_reference = nil
		
		def initialize(reference)
			raise Bib2::Error if !reference.is_a?(Bib2::AbstractReference)
			@input_reference = reference
		end
		
		pre(	:execute_enrichment_steps, 'Property @input_reference should be a Bib2::AbstractReference instance') { puts 'xx'; @input_reference.is_a?(Bib2::AbstractReference) }
		post(	:execute_enrichment_steps, 'Return value should be a Bib2::AbstractReference') { |result| result.is_a?(Bib2::AbstractReference) }		
		def execute_enrichment_steps			
		end
		
	protected
		pre(	'Parameter reference should be a Bib2::AbstractReference instance') { |reference| reference.is_a?(Bib2::AbstractReference) }
		pre(	'Parameter reference should have a title') { |reference| !reference.title.nil? }
		post(	'Return value should be a Bib2::AbstractResponse') { |result, reference| result.is_a?(Bib2::AbstractResponse) }
		def collect_references(reference)
		end
		
		pre(	'Parameter collected_references should be an Array') { |collected_references| collected_references.is_a?(Array) }
		post(	'Return value should be an Array with Bib2::FilteredReference instances') { |result, collected_references| result.is_a?(Array) }
		def filter_collected_references(collected_references)
		end
		
		pre(	'Parameter filtered_references should be an Array') { |filtered_references| filtered_references.is_a?(Array) }
		post(	'Return value should be a Bib2::AbstractReference instance') { |result, collected_references| result.is_a?(Bib2::AbstractReference) }
		def integrate_filtered_references(filtered_references)
		end
	end
end

module Bib2
	class EnrichmentHandlerX
		include Bib2::EnrichmentHandlerAbstract2
	end
end

class BibmixTest < ActiveSupport::TestCase
  
    
  # Simple test to check if the configuration method returns something.
 	def test_config
 		x = Bib2::EnrichmentHandlerX.new(Bib2::Reference.new)
 		x.execute_enrichment_steps
 	end
  
end
