require 'spec_helper'

describe 'ipam::install' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:pre_condition) { 'include ::ipam' }
      let(:node) { 'ipam1.contoso.ltd' }
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('dns::server') }
      it { is_expected.to contain_class('dhcp') }

    end
  end
#  context 'on redhat-7-x86_64 with default parmas' do
#    let(:pre_condition) { 'include ::ipam' }
#    let(:node) { 'ipam1.contoso.ltd' }
#    let :facts do
#      {
#        osfamily: 'RedHat',
#        os: { family: 'RedHat' },
#        os_maj_release: 7,
#      }
#    end
#    it { is_expected.not_to contain_package(apparmor).with_ensure('absent') }
#    ['bind-utils', 'perl-DB_File', 'perl-NetAddr-IP', 'bind-pkcs11-utils', 'net-snmp', 'ntpdate'].each do |package|
#      it { is_expected.to contain_package(package).with_ensure('latest') }
#    end
#    it { is_expected.to compile }
#  end
end
