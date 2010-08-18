require 'bib2'

module Bib2
	module Bibsonomy
		class TitleQueryEnrichmentHandler < Bib2::AbstractEnrichmentHandler
			include DesignByContract			
			
			pre('Parameter chaintoken should be a Bib2::ChainToken instance.') { |chaintoken| chaintoken.kind_of?(Bib2::ChainToken) }
			pre('ChainToken should contain a reference') { |chaintoken| chaintoken.reference.kind_of?(Bib2::AbstractReference) }
			post('Return value should be a Bib2::ChainToken') { |result| result.kind_of?(Bib2::ChainToken) }
			def execute_enrichment_steps(chaintoken)
				refs = collect_references(chaintoken.reference)
				
				chaintoken
			end
			
			protected
			
			pre('ChainToken reference should have a title') { |chaintoken| !chaintoken.reference.title.nil? }
			def collect_references(reference)
				Bib2::Bibsonomy::TitleQuery.new(reference.title)
			end
			
			def filter_collected_references
				raise Bib2::NotImplementedError
			end
			
			def integrate_filtered_references
				raise Bib2::NotImplementedError
			end
			
			
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