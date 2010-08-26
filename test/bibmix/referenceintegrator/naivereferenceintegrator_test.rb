require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibmix_NaiveReferenceIntegratorTest < ActiveSupport::TestCase
  include Bibmix
  
  def setup
  	@reference1 = Reference.from_hash({
			:id => '_test_hash_',
			:title => 'testa'
		})
    @reference2 = Reference.from_hash({
			:id => 'other_test_hash',
			:title => 'testb',
			:year => 2009
		})		
		@reference3 = Reference.from_hash({
			:id => 'other_test_hash_yet',
			:title => 'testc',
			:year => 2009
		})
		
		collected_reference = CollectedReference.new(@reference2, 'unknown source')
    @filtered1 = FilteredReference.new(collected_reference, 1.0)
    
		collected_reference = CollectedReference.new(@reference3, 'unknown source')
    @filtered2 = FilteredReference.new(collected_reference, 0.9)
				
		@integrator_class = NaiveReferenceIntegrator
  end
  
  def teardown
  	
  end
  
  def test_constructor
  	
  	assert_nothing_raised{
  		integrator = @integrator_class.new(@reference1)
  	}
  	
  	assert_raise(Bibmix::Error){
  		integrator = @integrator_class.new(nil)
  	}
  end
  	
	def test_integrate_array
		
    
    refs = [@filtered1, @filtered2]
    
    integrator = @integrator_class.new(@reference1)
    
    integrated_reference = nil
    assert_nothing_raised {
	    integrated_reference = integrator.integrate(refs)
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
	
	def test_integrate_single
		
    integrator = @integrator_class.new(@reference1)
    
    integrated_reference = nil
    assert_nothing_raised {
	    integrated_reference = integrator.integrate(@filtered1)
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
