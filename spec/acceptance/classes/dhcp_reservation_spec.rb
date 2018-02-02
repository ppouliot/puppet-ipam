require 'spec_helper_acceptance'

describe 'ipam::dhcp_reservation ipam::dhcp_reservation' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
      ipam::dhcp_reservation{'some_value':
        mac: nil,
        ip: nil,

      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
