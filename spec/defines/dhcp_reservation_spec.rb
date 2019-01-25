require 'spec_helper'

describe 'ipam::dhcp_reservation' do
  let(:title) { 'namevar' }
  let(:pre_condition) { 'include ::ipam::config' }
  let(:params) do
    {
      mac: '00:0c:29:55:26:f8',
      ip: '192.168.0.2',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_dhcp__host('namevar')
          .with(
            mac: '00:0c:29:55:26:f8',
            ip: '192.168.0.2',
            require: 'Class[Ipam::Config]',
          )
      }
    end
  end
end
