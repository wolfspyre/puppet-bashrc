require 'spec_helper'

describe 'bashrc::promptcolor', :type => 'class' do
  context 'on supported platforms' do
    let :facts do { :osfamily => 'RedHat'} end
    it { should include_class('bashrc::params') }
    it { should include_class('bashrc::rhel') }
    it { should contain_file('/etc/bashrc.d/promptcolor.sh')}
    end
end