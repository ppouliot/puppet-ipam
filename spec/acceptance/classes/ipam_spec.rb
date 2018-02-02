require 'spec_helper_acceptance'

describe 'ipam class' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
      class{'ipam':
        # master: [],
        # primary: [],
        # ddnskey: [],
        # slave: [],
        # dhcpdata: [],
        # static_leases: [],
        # dns_records_a: [],
        # dns_records_cname: [],
        # dhcp_use_failover: true,
        # primary_defaults: {},
        # slave_defaults: {},

      }
      EOS

    # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end
end
