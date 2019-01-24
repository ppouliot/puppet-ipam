require 'spec_helper'
describe 'ipam' do
  let(:title) { 'ipam' }
  let(:node) { 'ipam1.contoso.ltd' }
  let(:facts) { { is_virtual: false } }

  on_supported_os.reject { |_, f| f[:os]['family'] == 'Solaris' }.each do |os, f|
    context "on #{os}" do
      let(:facts) do
        f.merge(super())
      end

      # this is the simplest test possible to make sure the Puppet code compiles
      it { is_expected.to compile }
      # same as above except it will test all the dependencies
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('ipam::install') }
      it { is_expected.to contain_class('ipam::config') }
      it { is_expected.to contain_class('ipam::install').that_comes_before('Class[ipam::config]') }
      # same again except it expects an error message
      # it { is_expected.to compile.and_raise_error(/error message/)
    end
  end
end
