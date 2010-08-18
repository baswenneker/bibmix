require 'bib2'

module Bib2
	module Bibsonomy
		class AuthorQueryEnrichmentHandler
			include Bib2::EnrichmentHandlerAbstract
			
			protected
			def execute_chain_action(chainrecord)
				
				# Set the status to empty result in the beginning			
				record = chainrecord.record
				
				# Start looping over authors and try to find matching titles.
				author_queries = []
				record.author.each do |q|
					
					# Query on author name.
					query = Bib2::Bibsonomy::AuthorQuery.new(q)
					if query.response.size > 0
						author_queries << query
					end
				end
				
				self.log("author queries with results: #{author_queries.size}")
				
				threshold = Bib2.get_config('author_recordlinker_threshold')
				
				begin
					# Merge the results.
					merger = Bib2::RecordLinker.new(record, author_queries)
					merger = FilterDecoratorFactory.instance.fril(merger)
					merged_record = merger.merge(threshold)
					
					chainrecord.set_merged_record(merged_record, Bib2::AbstractEnrichmentHandler::STATUS_AUTHOR_MERGED, Bib2::AbstractEnrichmentHandler::STATUS_AUTHOR_NOT_MERGED)
				rescue Bib2::RecordLinkerError => e
					chainrecord.condition = Bib2::AbstractEnrichmentHandler::STATUS_AUTHOR_NOT_MERGED
					self.log("empty response for #{author_queries} - #{e}")
				end			
				
				chainrecord
			end
		end
	end
end