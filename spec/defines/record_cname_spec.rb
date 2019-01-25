require 'spec_helper'

describe 'ipam::record_cname' do
  let(:title) { 'namevar' }
  let(:pre_condition) { 'include ::dns::server' }
  let(:post_condition) { 'include ::ipam::config' }
  let(:params) do
    {
      zone: 'contoso.ltd',
      data: '192.168.0.2',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_dns__record__cname('namevar')
          .with(
            zone: 'contoso.ltd',
            data: '192.168.0.2',
            require: 'Class[Ipam::Config]',
          )
      }
    end
  end
end
