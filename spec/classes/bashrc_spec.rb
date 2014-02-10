require 'spec_helper'

describe 'bashrc', :type => 'class' do
  context 'input validation' do
    ['bashrcdir','etcbashfile','skelfile'].each do |paths|
      context "when not fed a valid file path to the #{paths} parameter" do
        let (:params) {{ 'python' => 'foo' }}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
        end
      end#each path
    end#paths each

    ['enable_git_completion','enable_prompt_mods','prompt_color_enable','prompt_git'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let (:params) {{bools => "BOGON"}}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end

#    [''].each do |strings|
#      context "when the #{strings} parameter is not a string" do
#        let (:params) {{strings => false }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
#        end
#      end
#    end
#  end
  ['Debian','RedHat'].each do |osfam|
    context "When on an #{osfam} system" do
end
