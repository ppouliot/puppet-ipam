require 'spec_helper'

describe 'ipam::primary_zone' do
  let(:title) { 'namevar' }
  let(:pre_condition) { 'include ::dns::server' }
  let(:post_condition) { 'include ::ipam::config' }
  let(:params) do
    {
      soa: 'ipam1.contoso.ltd',
      soa_email: 'admin.contoso.ltd',
      nameservers: ['ipam1.contoso.ltd', 'ipam2.contoso.ltd'],
      allow_transfer: ['192.168.0.2', '192.168.0.3'],
      allow_update: ['key "omapi_key"'],
      also_notify: ['192.168.0.2'],
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
