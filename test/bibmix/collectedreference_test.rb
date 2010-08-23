require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibmix_CollectedReferenceTest < ActiveSupport::TestCase
  include Bibmix
  
	def test_constructor
		reference = Reference.new
		source = 'SomeSource'
		
		assert_nothing_raised{
			CollectedReference.new(reference, source)
		}
		
		assert_raise(Bibmix::Error){
			CollectedReference.new(reference, nil)
		}
		assert_raise(Bibmix::Error){
			CollectedReference.new(nil, nil)
		}
		assert_raise(Bibmix::Error){
			CollectedReference.new(nil, source)
		}
	end
  
end
