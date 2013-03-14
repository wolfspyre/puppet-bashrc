require 'spec_helper'

describe 'bashrc::rhel', :type => 'class' do
  context 'on supported platforms' do
    let :facts do { :osfamily => 'RedHat'} end
    it { should include_class('bashrc::params') }
    it { should contain_file('/etc/bashrc.d')}
    it { should contain_file('/etc/skel/.bashrc')}
    end
end