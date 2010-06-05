module Bibmix
	def self.log(obj, message)
		classname = obj.class.to_s.split('::').last
		Rails.logger.info("#{classname}: #{message}.")
	end
end

require 'decorator'
require 'bibmix/error'
require 'bibmix/query'
require 'bibmix/querymerger'
require 'bibmix/record'
require 'bibmix/request'
require 'bibmix/cacherequest'
require 'bibmix/chain'
require 'bibmix/response'