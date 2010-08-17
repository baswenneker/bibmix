require 'bib2'

module Bib2
	class RecordLinkerError < Bib2::Error;	end
	class RecordLinkerInvariantError < RecordLinkerError;	end
		
	class RecordLinker
		
		attr_reader :base, :query, :result
		attr_accessor :similarity_lookup_hash
		
		def initialize(base, query)
			@base = base
			@query = query
			@result = nil
			@similarity_lookup_hash = {}
		end
		
		def merge(similarity_threshold=false)				
			raise RecordLinkerInvariantError unless invariant
							
			hash = {}
			if @query.kind_of?(Array)
				# When querying for authors, @query is an array.
				@query.each do |query|
					hash = hash.merge(similar_record_hash(query))
				end
			else
				hash = similar_record_hash(@query)
			end
			
			if similarity_threshold == false
				similarity_threshold = Bib2.get_config('default_recordlinker_threshold', 0.5)
			end
			
			@result = merge_weighted_hash(hash, similarity_threshold)
		end
		
		# returns a hash with record.id:[similarity, record] pairs based on the
		# query and the base record
		def similar_record_hash(query=@query, base=@base)
							
			result = {}				
			query.response.each do |record|
				
				# assess the similarity of the record compared to the base record
				similarity = assess_similarity(base, record)
				
				if result.has_key?(record.id)
					# get the maximum similarity when the intrahash already existed
					similarity = [similarity, result[record.id][0]].max					
				end
				
				# store the similarity and record in the result hash
				result[record.id] = [similarity, record]
			end
			
			result
		end
		
		def assess_similarity(rec1, rec2)
			
			if !(rec1.kind_of?(Bib2::AbstractReference) || rec2.kind_of?(Bib2::AbstractReference))
				raise Bib2::RecordLinkerError, "One of the params is not a Record, (#{rec1.inspect},#{rec2.inspect})"
			end
			
			["title", "intrahash"].each do |key|
				next if rec1.send(key).nil? || rec2.send(key).nil?
				
				return 0 if rec1.send(key).size == 0 || rec2.send(key).size == 0
				return 1 if rec1.send(key) == rec2.send(key)
			end
			
			if @similarity_lookup_hash.key?(rec2.id)
				return @similarity_lookup_hash[rec2.id]
			end
			
			0
		end
		
	protected
		def invariant
			@base.kind_of?(Bib2::AbstractReference) && (
				@query.kind_of?(Bib2::AbstractReferenceCollector) ||
				@query.kind_of?(Array)
			)
		end
		
		def merge_weighted_hash(hash, threshold=0)
			similar_records = hash.sort {|a,b| a[0]<=>b[0]}
			
			similar_records.each do |record|
				if record[1][0] >= threshold
					@base = @base.merge(record[1][1])
				end
			end
			@base
		end
	end
end