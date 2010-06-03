require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		class AuthorQueryChain < Bibmix::Bibsonomy::Chain
			
			protected
			def execute_chain_action(chainrecord)
				
				#raise MixingProcessInvariantError unless invariant
				#raise MixingProcessMissingTitleError if !@base.author.kind_of?(Array) || @base.author.size == 0
				
				# Set the status to empty result in the beginning
				#@status = RESULT_AUTHOR_QUERY_EMPTY			
				record = chainrecord.record
				# Start looping over authors and try to find matching titles.
				author_queries = []
				record.author.each do |q|
					
					# Query on author name.
					query = Bibmix::Bibsonomy::AuthorQuery.new(q)
					if query.response.size > 0
						author_queries << query
					end
				end
				
				self.log("author queries with results: #{author_queries.size}")
				
				begin
					# Merge the results.
					chainrecord.record = Bibmix::Bibsonomy::AuthorQueryMerger.new(record, author_queries).merge
					chainrecord.condition = Chain::STATUS_AUTHOR_MERGED
					self.log('successfully merged author, setting chainrecord condition to STATUS_AUTHOR_MERGED')
				rescue QueryMergerError => e
					self.log("empty response for #{author_queries} - #{e}")
				end			
				
				chainrecord
			end
		end
	end
end