require 'spec_helper'

describe 'ipam::slave_zone' do
  let(:title) { 'namevar' }
  let(:pre_condition) { 'include ::dns::server' }
  let(:post_condition) { 'include ::ipam::config' }
  let(:params) do
    {
      slave_masters: '192.168.0.2',
      zone_type: 'slave',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_dns__zone('namevar')
          .with(
            slave_masters: '192.168.0.2',
            zone_type: 'slave',
            require: 'Class[Ipam::Config]',
          )
      }
    end
  end
end
