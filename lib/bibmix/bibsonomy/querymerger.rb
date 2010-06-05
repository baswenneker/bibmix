require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		
		class QueryMerger < Bibmix::QueryMerger
			
			def merge(*args)				
				raise Bibmix::NotImplementedError
			end
			
			# returns a hash with record.id:[similarity, record] pairs based on the
			# query and the base record
			def similar_record_hash(query=@query, base=@base)
				
				if query.response.size == 0
					Bibmix.log(self, 'query response was empty, nothing to merge')
					return {}
				end
				
				result = {}				
				query.response.each do |record|
					
					# assess the similarity of the record compared to the base record
					similarity = assess_similarity(base, record)
					
					if result.key?(record.id)
						# get the maximum similarity when the intrahash already existed
						similarity = [similarity, result[record.id][0]].max					
					end
					
					# store the similarity and record in the result hash
					result[record.id] = [similarity, record]
				end
				
				result
			end
			
			def assess_similarity(rec1, rec2)
				
				if !(rec1.kind_of?(Bibmix::Bibsonomy::Record) || rec2.kind_of?(Bibmix::Bibsonomy::Record))
					raise Bibmix::QueryMergerError, "One of the params is not a Record, (#{rec1.inspect},#{rec2.inspect})"
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
				@base.kind_of?(Bibmix::Bibsonomy::Record) && @query.kind_of?(Bibmix::Bibsonomy::Query)
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
end