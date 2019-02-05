require 'spec_helper_acceptance'

describe 'ipam::slave_zone ipam::slave_zone' do
  describe 'running puppet code' do
    it 'might work with no errors' do
      pp = <<-EOS
      ipam::slave_zone{'ad.contoso.ltd':
        slave_masters => '192.168.0.1',
        zone_type =>  'slave',

      }
   EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
