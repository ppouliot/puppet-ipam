require 'spec_helper_acceptance'

describe 'ipam::primary_zone ipam::primary_zone' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
      ipam::primary_zone{'some_value':
        soa: nil,
        soa_email: nil,
        nameservers: nil,
        allow_transfer: nil,
        allow_update: nil,
        also_notify: nil,

      }
      EOS

    # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end
end
