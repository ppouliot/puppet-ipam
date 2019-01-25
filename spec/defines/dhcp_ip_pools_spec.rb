require 'spec_helper'

describe 'ipam::dhcp_ip_pools' do
  let(:title) { 'namevar' }
  let(:pre_condition) { 'include ::ipam::config' }
  let(:params) do
    {
      failover: 'dhcp-failover',
      network: '192.168.0.0',
      mask: '255.255.255.0',
      gateway: '192.168.0.254',
      range: '192.168.0.25 192.168.0.220',
      options: ['domain-name-servers 192.168.0.2, 192.168.0.3', 'domain-name "contoso.ltd"'],
      parameters: ['ddns-domainname "contoso.ltd."'],
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_dhcp__pool('namevar')
          .with(
            failover: 'dhcp-failover',
            network: '192.168.0.0',
            mask: '255.255.255.0',
            gateway: '192.168.0.254',
            range: '192.168.0.25 192.168.0.220',
            options: ['domain-name-servers 192.168.0.2, 192.168.0.3', 'domain-name "contoso.ltd"'],
            parameters: ['ddns-domainname "contoso.ltd."'],
          )
      }
    end
  end
end
