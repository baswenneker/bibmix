require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		
		class AuthorQueryMergerError < Bibmix::Bibsonomy::QueryMergerError
		end
		
		class AuthorQueryMergerInvariantError < AuthorQueryMergerError
		end
	
		class AuthorQueryMergerEmptyQueryResultError < AuthorQueryMergerError
		end
	
		class AuthorQueryMergerInvalidSimilarityParamError < AuthorQueryMergerError
		end
			
		class AuthorQueryMerger < Bibmix::Bibsonomy::QueryMerger
			
			def initialize(base, query)
				super(base, query)
				@lookup_table = {}
			end
			
			def merge(*args)
				raise AuthorQueryMergerInvariantError unless invariant
				
				# The intrahashes are used to filter out duplicate entries.
				# Read more about hashes @bibsonomy: <http://www.bibsonomy.org/help/doc/inside.html>
				similar_records = {}
				@query.each do |query|
					query.response.each do |record|
						similarity = assess_similarity(@base, record)
						@lookup_table[record.intrahash] = similarity
						if similarity > 0.75
							puts '#####', record.to_yaml
							similar_records[record.intrahash] = [similarity, record]
						end
					end
				end
				
				raise AuthorQueryMergerEmptyQueryResultError if similar_records.size == 0
				
	#			puts similar_records.to_yaml
				similar_records = similar_records.sort {|a,b| a[0]<=>b[0]}
				similar_records.each do |record|
					@base = @base.merge(record[1][1])
				end
				
				@result = @base
			end
			
			def assess_similarity(rec1, rec2)
				if !(rec1.kind_of?(Bibmix::Record) || rec2.kind_of?(Bibmix::Record))
					raise AuthorQueryMergerInvalidSimilarityParamError, "One of the params is not a Record, (#{rec1.inspect},#{rec2.inspect})"
				end
				
				["title", "intrahash"].each do |key|
					next if rec1.send(key).nil? || rec2.send(key).nil?
					
					return 0 if rec1.send(key).size == 0 || rec2.send(key).size == 0
					return 1 if rec1.send(key) == rec2.send(key)
				end
				
				if @lookup_table.key?(rec2.intrahash)
					return @lookup_table[rec2.intrahash]
				end
				
				title_sim = rec1.title.pair_distance_similar(rec2.title)
	
				if title_sim > 0.75
					return title_sim
				end
				
				0
			end
		protected
			def invariant
				@base.kind_of?(Bibmix::Record) && @query.kind_of?(Array)
			end
		end
	end
end