require 'bib2'

module Bib2
	module Bibsonomy
		class TitleQueryEnrichmentHandler < Bib2::AbstractEnrichmentHandler
			
			protected
			def execute_chain_action(chainrecord)
				
				record = chainrecord.record
				raise Bib2::Error.new('No title available in the record.') if !record.title
				
				self.log("record.title = '#{record.title}'")
				
				collector = Bib2::Bibsonomy::TitleQuery.new(record.title)
				
				if collector.response.size > 0
					
					threshold = Bib2.get_config('title_recordlinker_threshold')
					
					begin
						filter = ReferenceFilter.new(record, query)
						filter = FilterDecoratorFactory.instance.fril(filter)	
						
						filtered_references = filter.filter(threshold)
						
						integrator = NaiveReferenceIntegrator.new(record)
						integrated_record = integrator.integrate(filtered_references)
						
#						merger = RecordLinker.new(record, query)
#						merger = FilterDecoratorFactory.instance.fril(merger)						
#						merged_record = merger.merge(threshold)
						
						chainrecord.set_merged_record(merged_record, AbstractEnrichmentHandler::STATUS_TITLE_MERGED, AbstractEnrichmentHandler::STATUS_TITLE_NOT_MERGED)
					rescue Bib2::RecordLinkerError => e						
						chainrecord.condition = AbstractEnrichmentHandler::STATUS_TITLE_NOT_MERGED
						self.log("error occurred, setting chainrecord condition to STATUS_NOT_MERGED. Error: #{e}")
					end
					
				else
					self.log('empty query response, setting chainrecord condition to STATUS_NOT_MERGED')
					chainrecord.condition = AbstractEnrichmentHandler::STATUS_TITLE_NOT_MERGED
				end

				chainrecord
			end
		end
	end
end