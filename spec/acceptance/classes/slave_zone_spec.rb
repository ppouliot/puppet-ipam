require 'spec_helper_acceptance'

describe 'ipam::slave_zone ipam::slave_zone' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
      ipam::slave_zone{'some_value':
        slave_masters: nil,
        zone_type: nil,

      }
   EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
