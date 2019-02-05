require 'spec_helper_acceptance'

describe 'ipam::record_a ipam::record_a' do
  describe 'running puppet code' do
    it 'might work with no errors' do
      pp = <<-EOS
      ipam::record_a{'arecord':
        zone => 'contoso.ltd',
        data => '192.168.0.2',
        ptr => true,

      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
