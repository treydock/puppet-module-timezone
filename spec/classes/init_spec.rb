require 'spec_helper'
describe 'zone' do

  context 'with defaults for all parameters' do
    it { should contain_class('zone') }
  end
end
