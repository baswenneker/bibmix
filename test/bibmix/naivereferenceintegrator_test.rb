require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibmix_NaiveReferenceIntegratorTest < ActiveSupport::TestCase
  include Bibmix
  	
  def test_constructor
  	
  	ref1 = Reference.from_hash({
			:intrahash => '_test_hash_',
			:title => 'testa'
		})
  	
  	assert_nothing_raised{
  		integrator = NaiveReferenceIntegrator.new(ref1)
  	}
  	
  	assert_raise(Bibmix::Error){
  		integrator = NaiveReferenceIntegrator.new(nil)
  	}
  end
  	
	def test_integrate
		
    ref1 = Reference.from_hash({
			:intrahash => '_test_hash_',
			:title => 'testa'
		})
		
    ref2 = Reference.from_hash({
			:intrahash => 'other_test_hash',
			:title => 'testb',
			:year => 2009
		})
    
    collected_reference = CollectedReference.new(ref2, 'unknown source')
    filtered_reference = FilteredReference.new(collected_reference, 1.0)
    
    integrator = NaiveReferenceIntegrator.new(ref1)
    
    integrated_reference = nil
    assert_nothing_raised {
	    integrated_reference = integrator.integrate(filtered_reference)
    }
		
		assert_equal(ref2.year, integrated_reference.year)
		assert_equal(ref1.title, integrated_reference.title)
		
		assert_raise(RuntimeError) {
	    integrated_reference = integrator.integrate(ref2)
		}
		
		assert_raise(RuntimeError) {
	    integrated_reference = integrator.integrate(nil)
		}
	end
  
end
