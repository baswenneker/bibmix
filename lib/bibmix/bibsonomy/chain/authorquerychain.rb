require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		class AuthorQueryChain < Bibmix::Bibsonomy::Chain
			
			protected
			def execute_chain_action(chainrecord)
				
				# Set the status to empty result in the beginning			
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
				
				threshold = Bibmix.get_config('author_recordmerger_threshold')
				
				begin
					# Merge the results.
					merger = Bibmix::RecordMerger.new(record, author_queries)
					merger = MergerDecoratorFactory.instance.title(merger)
					merged_record = merger.merge(threshold)
					
					chainrecord.set_merged_record(merged_record, Chain::STATUS_AUTHOR_MERGED, Chain::STATUS_AUTHOR_NOT_MERGED)
				rescue Bibmix::RecordMergerError => e
					chainrecord.condition = Chain::STATUS_AUTHOR_NOT_MERGED
					self.log("empty response for #{author_queries} - #{e}")
				end			
				
				chainrecord
			end
		end
	end
end