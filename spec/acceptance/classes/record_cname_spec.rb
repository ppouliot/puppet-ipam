require 'spec_helper_acceptance'

describe 'ipam::record_cname ipam::record_cname' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
      ipam::record_cname{'some_value':
        zone: nil,
        data: nil,

      }
      EOS

    # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end
end
