require 'bibmix/bibsonomy'
require 'httpclient'
require 'cgi'

module Bibmix
	module Bibsonomy
	
		class RequestError < Bibmix::Error
		end
		
		class InvalidRequestConfigFileError < RequestError 
		end
		
		class MissingRequestUsernameError < RequestError 
		end
	
		class MissingRequestApiKeyError < RequestError	
		end
	
		class UnimplementedFormatError < RequestError
		end
	
		class Request < Bibmix::Request
			DEFAULT_CONFIG = "#{File.dirname(__FILE__)}/../../config/bibsonomy_request_config.yml"
			
	    def initialize
	    	init_config
	   	end
	   	
	   	def init_config(file=DEFAULT_CONFIG)
	   		begin
	    		@config = YAML.load_file(file)['default']
	    	rescue
	    		raise Bibmix::Bibsonomy::InvalidRequestConfigFileError, "Invalid file, please provide a valid configuration (#{file})"
	    	end
	   	end
	   
	   	def send(q = '', api_type = 'posts')
			  
			  q = preprocess_query(q)		  
			  client = get_client()
			  
			  response = client.get_content("http://www.bibsonomy.org/api/#{api_type}?resourcetype=bibtex&start=0&end=500&format=#{@config['format']}&search=#{q}")
			  Rails.logger.info "[bibsonomy] Request::send $ http://www.bibsonomy.org/api/#{api_type}?resourcetype=bibtex&start=0&end=50&format=#{@config['format']}&search=#{q}"
			 
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