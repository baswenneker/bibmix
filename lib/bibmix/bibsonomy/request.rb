require 'bibmix'
require 'httpclient'
require 'cgi'

module Bibmix
	module Bibsonomy
	
		class RequestError < Bibmix::Error; end
		class RequestConfigNotFoundError < RequestError;	end
		class MissingRequestUsernameError < RequestError;	end
		class MissingRequestApiKeyError < RequestError;	end
		class UnimplementedFormatError < RequestError; end
	
		class Request < Bibmix::CacheRequest
			include DesignByContract			
			
	    def initialize
	    	init_config
	   	end
	   	
	   	# Initializes the configuration used to query bibsonomy.
	   	def init_config
	   		@config = Bibmix::get_config('bibsonomy_api')
	    	if @config == false
	    		raise Bibmix::Bibsonomy::RequestConfigNotFoundError, "Config not found, please provide a valid configuration."
	    	end
	    	@use_caching = Bibmix::get_config('request_caching', true)
	   	end
	   
	   	def send(q = '', api_type = 'posts')
			  
			  q = preprocess_query(q)		  
			  client = get_client()
			  
			  request_uri = "http://www.bibsonomy.org/api/#{api_type}?resourcetype=bibtex&start=0&end=1000&format=#{@config['format']}&search=#{q}"
			  
			  if @use_caching
				  response = from_cache(request_uri)
				  if response.nil?
				  	response = client.get_content(request_uri)			  	
				  	to_cache(request_uri, response)
				  end
				else
					response = client.get_content(request_uri)	
				end
			  
			  Bibmix.log(self, "request_uri = #{request_uri}")
			 
			  process_response(response)
			end
	  
	  	def preprocess_query(q, remove_meta = true)
	  		q = q.gsub(/:/, ' ') if remove_meta
	  		q = q.gsub(/\s*-\s*/, ' ') if remove_meta  
	  		CGI.escape(q)
	  	end
	  
	  protected
	  	
	  	def process_response(r)
	  		
	  		if @config['format'] == 'xml'
	  			response = Bibmix::Bibsonomy::XMLResponse.new(r)
	  		else
	  			raise Bibmix::Bibsonomy::UnimplementedFormatError, "Format not yet implemented (#{@config['format']})."
	  		end
	  		
	  		response
	  	end
	  
	  	def get_client
	  		
	  		if !@config['username']
	   			raise Bibmix::Bibsonomy::MissingRequestUsernameError, "Username is missing, please provide a valid Bibsonomy username in the config file."
	   		elsif !@config['api_key'] 
	   			raise Bibmix::Bibsonomy::MissingRequestApiKeyError, "Api key is missing, please provide a valid Bibsonomy api key in the config file."
	   		end
	   		
			  client = HTTPClient.new
			  client.set_auth('http://www.bibsonomy.org/', @config['username'], @config['api_key'])
		
			  client
	  	end
		end
	end
end