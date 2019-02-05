require 'spec_helper_acceptance'

describe 'ipam::dhcp_ip_pools ipam::dhcp_ip_pools' do
  describe 'running puppet code' do
    it 'might work with no errors' do
      pp = <<-EOS
      ipam::dhcp_ip_pools{'some_value':
        failover: nil,
        network: nil,
        mask: nil,
        gateway: nil,
        range: nil,
        options: nil,
        parameters: nil,

      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
