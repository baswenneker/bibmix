require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		class TitleQueryChain < Bibmix::Bibsonomy::Chain
			
			protected
			def execute_chain_action(chainrecord)
				
				record = chainrecord.record
				raise Bibmix::Error.new('No title available in the record.') if !record.title
				
				self.log("record.title = '#{record.title}'")
				
				query = Bibmix::Bibsonomy::TitleQuery.new(record.title)
				
				if query.response.size > 0
					
					threshold = Bibmix.get_config('title_recordlinker_threshold')
					
					begin
						merger = RecordLinker.new(record, query)
						merger = MergerDecoratorFactory.instance.fril(merger)						
						merged_record = merger.merge(threshold)
						
						chainrecord.set_merged_record(merged_record, Chain::STATUS_TITLE_MERGED, Chain::STATUS_TITLE_NOT_MERGED)
					rescue Bibmix::RecordLinkerError => e						
						chainrecord.condition = Chain::STATUS_TITLE_NOT_MERGED
						self.log("error occurred, setting chainrecord condition to STATUS_NOT_MERGED. Error: #{e}")
					end
					
				else
					self.log('empty query response, setting chainrecord condition to STATUS_NOT_MERGED')
					chainrecord.condition = Chain::STATUS_TITLE_NOT_MERGED
				end

				chainrecord
			end
		end
	end
end