require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibsonomy_ReferenceLinkerTest < ActiveSupport::TestCase
  include Bib2
  	
	def test_integration
		
    ref1 = Reference.from_hash({
			:intrahash => '_test_hash_',
			:title => 'testa'
		})
		
    ref2 = Reference.from_hash({
			:intrahash => 'other_test_hash',
			:title => 'testb',
			:year => 2009
		})
    
    integrator = NaiveReferenceIntegrator.new(ref1)
    integrated_reference = integrator.integrate(ref2)
		
		assert_equal(ref2.year, integrated_reference.year)
		assert_equal(ref1.title, integrated_reference.title)
	end
  
end
