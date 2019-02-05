require 'spec_helper_acceptance'

describe 'ipam::record_cname ipam::record_cname' do
  describe 'running puppet code' do
    it 'might work with no errors' do
      pp = <<-EOS
      ipam::record_cname{'cnamerecord':
        zone => 'contoso.ltd',
        data => '192.168.0.2',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
