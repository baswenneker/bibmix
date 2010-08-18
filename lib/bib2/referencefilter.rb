require 'bib2'

module Bib2
	class ReferenceFilter
		include DesignByContract
		
		attr_reader :reference_for_comparison, :collected_references, :filtered_references
		attr_accessor :similarity_lookup_hash, :relevance_threshold
		
		def initialize(reference_for_comparison, collected_references)
			raise Bibmix::Error if !reference_for_comparison.is_a?(Bib2::AbstractReference) 
			raise Bibmix::Error if !collected_references.is_a?(Array) || !collected_references.inject(true){|is_a,item| is_a && item.is_a?(Bib2::CollectedReference) }
			
			@reference_for_comparison = reference_for_comparison
			@collected_references = collected_references
			@relevance_threshold = Bib2.get_config('default_relevance_threshold', 0.5)
			reset
		end
		
		post(	'Property @relevance_threshold should be a Float instance between 0 and 1') { @relevance_threshold.is_a?(Float) && @relevance_threshold >= 0.0 && @relevance_threshold <= 1.0 }
		def relevance_threshold=(threshold)
			@relevance_threshold = [0.0, [1.0, threshold.to_f].min].max
		end
		
		pre( 'Parameter relevance_threshold should be false or a Float') { (@relevance_threshold === nil) || @relevance_threshold.is_a?(Float) }
		post(	'Return value should be an Array of Bib2::FilteredReference instances') { @filtered_references.is_a?(Array) && @filtered_references.inject(true){|is_a,item| is_a && item.is_a?(Bib2::FilteredReference) } }
		def filter
						
			relevance_hash = {}
			@collected_references.each do |collected_ref|
				
				reference = collected_ref.reference
				
				# Assess the relevance of the collected reference compared to the @reference_for_comparison
				relevance = compute_relevance_of_references(@reference_for_comparison, reference)
				
				if relevance >= relevance_threshold
					if relevance_hash.has_key?(reference.id)
						if relevance > relevance_hash[reference.id].relevance
							relevance_hash[reference.id] = FilteredReference.new(collected_ref, relevance)
						end
					else
						relevance_hash[reference.id] = FilteredReference.new(collected_ref, relevance)
					end
				end	
			end
			
			@filtered_references = relevance_hash.values
		end
		
		pre( 'Parameter ref1 should be a Bib2::AbstractReference instance') {|rec1, rec2| rec1.is_a?(Bib2::AbstractReference)}
		pre( 'Parameter ref2 should be a Bib2::AbstractReference instance') {|rec1, rec2| rec2.is_a?(Bib2::AbstractReference)}
		def compute_relevance_of_references(rec1, rec2)
						
			["title", "intrahash"].each do |key|
				next if rec1.send(key).nil? || rec2.send(key).nil?
				
				return 0.0 if rec1.send(key).size == 0 || rec2.send(key).size == 0
				return 1.0 if rec1.send(key) == rec2.send(key)
			end
			
			if @similarity_lookup_hash.key?(rec2.id)
				return @similarity_lookup_hash[rec2.id].to_f
			end
			
			0.0
		end
		
		post(	'Property @similarity_lookup_hash should be an empty Hash instance') { @similarity_lookup_hash.is_a?(Hash) && @similarity_lookup_hash.size == 0 }
		post(	'Property @filtered_references should be an empty Array instance') { @filtered_references.is_a?(Array) && @filtered_references.size == 0 }
		def reset
			@similarity_lookup_hash = {}
			@filtered_references = []
		end
	end
end