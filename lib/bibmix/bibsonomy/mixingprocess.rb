module Bibmix
	module Bibsonomy
		
		class MixingProcessError < Bibmix::MixingProcessError
		end
	
		class MixingProcessInvariantError < MixingProcessError
		end
	
		class MixingProcessMissingTitleError < MixingProcessError
		end
	
		class MixingProcessMissingAuthorError < MixingProcessError
		end
		
		class MixingProcess < Bibmix::MixingProcess
			
			STEP_TITLE_QUERY = 'step_title_query'
			STEP_AUTHOR_QUERY = 'step_author_query'
			RESULT_TITLE_QUERY_EMPTY = 'empty_result_title_query'
			RESULT_TITLE_QUERY_OK = 'ok_result_title_query'
			RESULT_AUTHOR_QUERY_EMPTY = 'empty_result_author_query'
			RESULT_AUTHOR_QUERY_OK = 'ok_result_author_query'
			RESULT_TOKENIZED_TITLE_QUERY_EMPTY = 'empty_result_tokenized_title_query'
			RESULT_TOKENIZED_TITLE_QUERY_OK = 'ok_result_tokenized_title_query'
			
			
			def execute
				run_titlequery_step
				if @status == RESULT_TITLE_QUERY_OK
					return @result
				else @status == RESULT_TITLE_QUERY_EMPTY
					run_authorquery_step
					if @status == RESULT_AUTHOR_QUERY_OK
						return @result
					else @status == RESULT_AUTHOR_QUERY_EMPTY
						#run_tokenized_titlequery_step
					end
				end
				
				@base
			end
			
		protected
			
			def run_titlequery_step
				@current_step = STEP_TITLE_QUERY
				raise MixingProcessInvariantError unless invariant
				raise MixingProcessMissingTitleError if !@base.title
				
				query = Bibmix::Bibsonomy::TitleQuery.new(@base.title)
				
				if query.response.size > 0
					begin
						@result = Bibmix::Bibsonomy::TitleQueryMerger.new(@base, query).merge
						@status = RESULT_TITLE_QUERY_OK
					rescue QueryMergerError
						@status = RESULT_TITLE_QUERY_EMPTY				
					end
				else
					@status = RESULT_TITLE_QUERY_EMPTY
				end
				
				Rails.logger.info("Step #{@current_step}-#{@status}")
			end
			
			def run_authorquery_step
				@current_step = STEP_AUTHOR_QUERY
				raise MixingProcessInvariantError unless invariant
				raise MixingProcessMissingTitleError if !@base.author.kind_of?(Array) || @base.author.size == 0
				
				# Set the status to empty result in the beginning
				@status = RESULT_AUTHOR_QUERY_EMPTY			
				
				# Start looping over authors and try to find matching titles.
				author_queries = []
				@base.author.each do |q|
					
					# Query on author name.
					query = Bibmix::Bibsonomy::AuthorQuery.new(q)
					if query.response.size > 0
						author_queries << query
					end
				end
				
				begin
					# Merge the results.
					@result = Bibmix::Bibsonomy::AuthorQueryMerger.new(@base, author_queries).merge
					@status = RESULT_AUTHOR_QUERY_OK
				rescue QueryMergerError => e
					Rails.logger.info("Step #{@current_step} - empty response for #{author_queries} - #{e}")
				end
							
				Rails.logger.info("Step #{@current_step}-#{@status}")
				
				@result
			end
			
			def run_tokenized_titlequery_step
				tokens = Tokenizer::tokenize(@base.citation)
				
				@status = RESULT_TOKENIZED_TITLE_QUERY_EMPTY
				tokens.each do |token|
					next if token.size <= 8
					
					query = Bibmix::Bibsonomy::TitleQuery.new(token)
				
					if query.response.size > 0
						begin
							@result = Bibmix::Bibsonomy::TitleQueryMerger.new(@base, query).merge
							@status = RESULT_TITLE_QUERY_OK
						rescue QueryMergerError				
						end
					end
					
				end
				
				Rails.logger.info("Step #{@current_step}-#{@status}")
			end
			
		end
	end
end