require 'spec_helper'
describe 'ipam' do
  let(:title) { 'ipam' }
  let(:node) { 'ipam1.contoso.ltd' }
  # this is the simplest test possible to make sure the Puppet code compiles
  it { is_expected.to compile }
  # same as above except it will test all the dependencies
  it { is_expected.to compile.with_all_deps }
  # same again except it expects an error message
  # it { is_expected.to compile.and_raise_error(/error message/)
end
