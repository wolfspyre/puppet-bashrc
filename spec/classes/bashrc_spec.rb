#!/usr/bin/env rspec
require 'spec_helper'

describe 'bashrc', :type => :class do
  context 'input validation' do

    ['bashrcdir','etcbashfile'].each do |paths|
      context "when the #{paths} parameter is not an absolute path" do
        let (:params) {{ paths => 'foo' }}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
        end
      end
    end#absolute path

#    ['array'].each do |arrays|
#      context "when the #{arrays} parameter is not an array" do
#        let (:params) {{ arrays => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not an Array./)
#        end
#      end
#    end#arrays

    ['enable_git_completion','enable_prompt_color','enable_prompt_mods','enable_svcstat','prompt_git_enable','purge_bashrcdir'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let (:params) {{bools => "BOGON"}}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end#bools

#    ['hash'].each do |hashes|
#      context "when the #{hashes} parameter is not an hash" do
#        let (:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#hashes

    ['prompt_leftblock','prompt_rightblock','prompt_separator'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {{strings => false }}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings

    context 'when svcstat_hash has a set value, but is not a hash' do
      let (:params) {{'svcstat_hash' => true}}
      it 'should fail' do
         expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
      end
    end
  end#input validation
  let (:default_params) {{

    }}
  ['Debian'].each do |osfam|
    context "When on an #{osfam} system" do
      let (:facts) {{'osfamily' => osfam}}
      context 'when fed no parameters' do
        ['bashrc','bashrc::params','bashrc::setup','bashrc::prompt','bashrc::svcstat'].each do |bashrclasses|
          it {
            should contain_class(bashrclasses)
          }
        end
        it 'should lay down /etc/profile.d' do
          should contain_file('/etc/profile.d').with({
            :path=>"/etc/profile.d",
            :ensure=>"directory",
            :owner=>"root",
            :group=>"root",
            :mode=>"0555",
            :purge=>true
          })
        end
        it 'should lay down prompt.sh' do
          should contain_file('/etc/profile.d/prompt.sh').with({
            :path=>"/etc/profile.d/prompt.sh",
            :ensure=>"file",
            :owner=>"0",
            :group=>"0",
            :mode=>"0555",
            :content=>"#!/bin/bash\n#\n#this file is responsible for setting the bash shell prompt for a user. it builds the prompt from values\n# fed to the bashrc module\n#Enable Colors\nreset=$(tput sgr0)\nred=$(tput setaf 1)\ngreen=$(tput setaf 2)\nyellow=$(tput setaf 3)\nblue=$(tput setaf 4)\npurple=$(tput setaf 5)\ncyan=$(tput setaf 6)\nwhite=$(tput setaf 7)\ncolone=$blue\ncoltwo=$white\ngitcol=$yellow\nif [ -f ~/.bashrc ]; then\n  #we have a user-specific bashrc. Hook into it so we're confident we get run \"last\"\n  if [ `grep -c /etc/profile.d/prompt.sh ~/.bashrc` -lt 1 ]; then\n    #we don't seem to have already introduced ourselves to the user's bashrc file. Lets go introduce ourselves\n    echo '#set the prompt to include nice pretty colors. Courtesy of bashrc::prompt, most specifically /etc/profile.d/prompt.sh' >> ~/.bashrc\n    echo '. /etc/profile.d/prompt.sh' >> ~/.bashrc\n  fi\nfi\n\nif [ $UID -eq 0 ]; then\n  export PS1=\"$red[\\[$colone\\]\\u\\[$white\\]@\\[$coltwo\\]\\h \\W\\[$gitcol\\]\\$(__git_ps1)\\[$reset\\]$red]$reset# \"\nelse\n  export PS1=\"[\\[$colone\\]\\u\\[$white\\]@\\[$coltwo\\]\\h \\W\\[$gitcol\\]\\$(__git_ps1)\\[$reset\\]]\\$ \"\nfi\n"
          })
        end

        it 'should lay down git-prompt.sh' do
          should contain_file('/etc/profile.d/git-prompt.sh').with({
            :path=>"/etc/profile.d/git-prompt.sh",
            :ensure=>"file",
            :owner=>"0",
            :group=>"0",
            :mode=>"0555",
            :source=>"puppet:///modules/bashrc/etc/profile.d/git_prompt.sh"
          })
        end
        it 'should lay down bash_completion.sh' do
          should contain_file('/etc/profile.d/bash_completion.sh').with({
            :path=>"/etc/profile.d/bash_completion.sh",
            :ensure=>"file",
            :owner=>"0",
            :group=>"0",
            :mode=>"0555",
            :source=>"puppet:///modules/bashrc/etc/profile.d/git_completion.sh"
          })
        end

        it 'should lay down svcstat.py' do
          should contain_file('bashrc::svcstat.py').with({
            :path=>"/usr/local/bin//svcstat.py",
            :ensure=>"file",
            :mode=>"0555",
            :source=>"puppet:///modules/bashrc/usr/local/bin/svcstat.py"
          })
        end
        it 'should lay down svcstat.sh' do
          should contain_file('bashrc::svcstat.sh').with({
            :path=>"/etc/profile.d/svcstat.sh",
            :content=>"#!/bin/bash\npython /usr/local/bin//svcstat.py\n",
            :mode=>"0555"
          })
        end
      end#no params

      context 'when prompt_leftblock has a custom value' do
        it 'should update the left side of the prompt accordingly' do
          pending 'we should write this'
        end
      end
      context 'when prompt_rightblock has a custom value' do
        it 'should update the right side of the prompt accordingly' do
          pending 'we should write this'
        end
      end
      context 'when prompt_separator has a custom value' do
        it 'should update the separator of the prompt accordingly' do
          pending 'we should write this'
        end
      end
      context 'when svcstat_hash has content' do
        context 'but it is not a hash' do
          it 'should fail' do
            pending 'we should write this'
          end
        end
        context 'and it is a hash' do
          it 'should iterate through each element of the hash. it should support hash elements with only the \'string\' key set, and elements with \'name\' and ,\'string\' set'do
            pending 'we should write this'
          end
        end
      end
      context 'when enable_git_completion is false' do
        it 'should not lay down the git completion script' do
          pending 'we should write this'
        end
      end
      context 'when enable_prompt_color is false' do
        ['prompt_primary_color','prompt_secondary_color','prompt_git_color'].each do |prompt_decorator|
          it "should verify that the #{prompt_decorator} param does nothing" do
            pending 'we should write these'
          end
        end
      end
      context 'when enable_prompt_mods is false' do

      end

      context 'when enable_svcstat is false' do
        it 'should not lay down svcstat files, and remove them if present' do
          pending 'we should write this'
        end
      end
      context 'when prompt_git_enable is false' do
        it 'should not lay down the prompt_git shell script, and should remove them if present' do
            pending 'we should write this'
          end
      end
      context 'when purge_bashrcdir is false' do
        it 'should not purge the directory' do
          pending 'we should write this'
        end
      end

    end#end specific osfam
  end#end osfam iterator
end
