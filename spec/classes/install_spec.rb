require 'spec_helper'

describe 'ipam::install' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:pre_condition) { 'include ::ipam' }
      let(:node) { 'ipam1.contoso.ltd' }
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
