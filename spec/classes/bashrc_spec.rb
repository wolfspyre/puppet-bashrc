require 'spec_helper'

describe 'bashrc', :type => 'class' do
  let (:default_params) do
    {
      'bashrcdir'              => '/ETC/BASHRCDIR',
      'enable_git_completion'  => true,
      'enable_prompt_mods'     => true,
      'etcbashfile'            => '/ETC/BASHFILE',
      'prompt_color_enable'    => true,
      'prompt_git_color'       => 'blue',
      'prompt_git_enable'      => true,
      'prompt_leftblock'       => '\u',
      'prompt_primary_color'   => 'blue',
      'prompt_rightblock'      => '\h \W',
      'prompt_secondary_color' => 'blue',
      'prompt_separator'       => '@',
      'puppetdir'              => '/tmp',
      'skelfile'               => '/ETC/SKELFILE'
    }
  end

  context 'input validation' do
    ['bashrcdir','etcbashfile','skelfile'].each do |paths|
      context "when not fed a valid file path to the #{paths} parameter" do
        let (:params) {default_params.merge({ paths => 'foo' })}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
        end
      end#paths context
    end#paths iterator

    ['enable_git_completion','enable_prompt_mods','prompt_color_enable','prompt_git_enable'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let (:params) {default_params.merge({bools => "BOGON"})}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end#bools context
    end#bools iterator

    ['prompt_primary_color', 'prompt_secondary_color','prompt_git_color'].each do |colors|
      context "when the #{colors} parameter does not match a supported color" do
        let (:params) {default_params.merge({colors => 'BOGON' })}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" does not match/)
        end
      end#colors context
    end#colors iterator
  end#input validator
  ['Debian','RedHat','Suse'].each do |osfam|
    context "When on an #{osfam} system" do
      let (:facts) {{ 'osfamily' => osfam }}
      let (:params) {default_params}
      it {should contain_class('bashrc::setup')}
      context 'when enable_prompt_mods is true' do
        let (:facts) {{ 'osfamily' => osfam }}
        let (:params) { default_params.merge({'enable_prompt_mods' => true, 'bashrcdir' => "/#{osfam}/bashrcdir"})}
        it 'should include the bashrc::prompt class' do
          should contain_class('bashrc::prompt')
        end
        it 'should contain the bashrc.d dir' do
          should contain_file("/#{osfam}/bashrcdir").with({
            :path=>"/#{osfam}/bashrcdir",
            :ensure=>"directory",
            :owner=>"root",
            :group=>"root",
            :mode=>"0555",
            :purge=>true
          })
        end#bashrc.d dir
        it 'should contain the skelfile' do
          should contain_file('/ETC/SKELFILE').with({
            :path=>"/ETC/SKELFILE",
            :ensure=>"file",
            :group=>"0",
            :mode=>"0644",
            :owner=>"0"
          })
        end#skelfile
        it 'should contain the exec which appends our sourcing script to the bashrc file' do
          should contain_exec('bashrc_append').with({
            :command=>"/bin/echo 'for i in /#{osfam}/bashrcdir/*.sh ; do . $i >/dev/null 2>&1; done' >>/ETC/BASHFILE",
            :unless=>"/bin/grep -q \"bashrc.d/\\*.sh\" /ETC/BASHFILE"
          })
        end#bashrc append exec
        if osfam == 'Debian'
          it 'should also contain the exec which appends our sourcing script to the bash_completion file' do
            should contain_exec('bash_completion_append').with({
              :command=>"/bin/echo 'for i in /Debian/bashrcdir/*.sh ; do . \$i >/dev/null 2>&1; done' >>/etc/bash_completion",
              :unless=>"/bin/grep -q \"bashrc.d/\\\\*.sh\" /etc/bash_completion"
            })
          end#bash_completion append exec
        end#only on debian hack

        it 'should contain the prompt shell script' do
          should contain_file("/#{osfam}/bashrcdir/prompt.sh").with({
            :ensure => 'file',
            :owner  => '0',
            :group  => '0',
            :mode   => '0555',
          })
        end

        context 'when the prompt_primary_color parameter has a value of \'red\'' do
          let (:facts) {{ 'osfamily' => osfam }}
          let (:params) { default_params.merge({'enable_prompt_mods' => true, 'bashrcdir' => "/#{osfam}/bashrcdir", 'prompt_primary_color' => 'red' })}
          it 'should set the primary color to red in the prompt shell script' do
            should contain_file("/#{osfam}/bashrcdir/prompt.sh").with_content(/colone=\$red/)
          end
        end#primary_color
        context 'when the prompt_secondary_color parameter has a value of \'purple\'' do
          let (:facts) {{ 'osfamily' => osfam }}
          let (:params) { default_params.merge({'enable_prompt_mods' => true, 'bashrcdir' => "/#{osfam}/bashrcdir", 'prompt_secondary_color' => 'purple' })}
          it 'should set the secondary color to purple in the prompt shell script' do
            should contain_file("/#{osfam}/bashrcdir/prompt.sh").with_content(/coltwo=\$purple/)
          end
        end#secondary_color

        {
          'prompt_leftblock'  => 'LEFTBLOCK',
          'prompt_rightblock' => 'RIGHTBLOCK',
          'prompt_separator'  => 'SEPARATOR'
        }.each_pair do |param, teststring|
          context "When the #{param} parameter has a custom value" do
            let (:facts) {{ 'osfamily' => osfam }}
            let (:params) { default_params.merge({'enable_prompt_mods' => true, 'bashrcdir' => "/#{osfam}/bashrcdir", param => teststring})}
            it "should set the #{param} part of the ps1 to the specified value" do
              should contain_file("/#{osfam}/bashrcdir/prompt.sh").with_content(/#{teststring}/)
            end
          end#each block
        end#param iterator

        context 'when the prompt_git_enable parameter is true' do
          let (:facts) {{ 'osfamily' => osfam }}
          let (:params) { default_params.merge({'enable_prompt_mods' => true, 'bashrcdir' => "/#{osfam}/bashrcdir", 'prompt_git_enable' => true, 'prompt_git_color' => 'purple' })}
          it 'should include the git ps1 string in the assembled ps1 variable in prompt.sh' do
            should contain_file("/#{osfam}/bashrcdir/prompt.sh").with_content(/__git_ps1/)
          end
          it 'should set the git string to be the color specified in the specified prompt_git_color parameter' do
            should contain_file("/#{osfam}/bashrcdir/prompt.sh").with_content(/__git_ps1/).with_content(/gitcol=\$purple/)
          end
        end#prompt_git_enable true

        context 'when the prompt_git_enable parameter is false' do
          let (:facts) {{ 'osfamily' => osfam }}
          let (:params) { default_params.merge({'enable_prompt_mods' => true, 'bashrcdir' => "/#{osfam}/bashrcdir", 'prompt_git_enable' => false })}
          it 'should not add the git ps1 string to the assembled ps1 string in prompt.sh' do
             should contain_file("/#{osfam}/bashrcdir/prompt.sh").with({:content=>"#!/bin/bash\n#\n#this file is responsible for setting the bash shell prompt for a user. it builds the prompt from values\n# fed to the bashrc module\n#Enable Colors\nreset=$(tput sgr0)\nred=$(tput setaf 1)\ngreen=$(tput setaf 2)\nyellow=$(tput setaf 3)\nblue=$(tput setaf 4)\npurple=$(tput setaf 5)\ncyan=$(tput setaf 6)\nwhite=$(tput setaf 7)\ncolone=$blue\ncoltwo=$blue\n\n\nif [ $UID -eq 0 ]; then\n  export PS1=\"[\\[$colone\\]\\u\\[$white\\]@\\[$coltwo\\]\\h \\W\\[$reset\\]]# \"\nelse\n  export PS1=\"[\\[$colone\\]\\u\\[$white\\]@\\[$coltwo\\]\\h \\W\\[$reset\\]]\\$ \"\nfi\n"})
          end
        end#prompt_git_enable_false

      end#prompt mods enabled

      context 'when enable_prompt_mods is false' do
        let (:facts) {{ 'osfamily' => osfam }}
        let (:params) { default_params.merge({'enable_prompt_mods' => false, 'bashrcdir' => "/#{osfam}/bashrcdir"})}

        it 'should not include the bashrc::prompt class' do
          should_not contain_class('bashrc::prompt')
        end
      end#prompt mods disabled
      context 'when enable_git_completion is true' do
        let (:facts) {{ 'osfamily' => osfam }}
        let (:params) { default_params.merge({'enable_git_completion' => true, 'bashrcdir' => "/#{osfam}/bashrcdir"})}
        it 'should contain the git bash_completion shell script' do
          should contain_file("/#{osfam}/bashrcdir/bash_completion.sh").with({
           :path=>"/#{osfam}/bashrcdir/bash_completion.sh",
           :ensure=>"file",
           :owner=>"0",
           :group=>"0",
           :mode=>"0555",
           :source=>"puppet:///modules/bashrc/etc/bashrc.d/git_completion.sh"
          })
        end
      end#enable_git_completion true
      context 'when enable_git_completion is false' do
        let (:facts) {{ 'osfamily' => osfam }}
        let (:params) { default_params.merge({'enable_git_completion' => false, 'bashrcdir' => "/#{osfam}/bashrcdir"})}
        it 'should not contain the git bash_completion shell script' do
          should_not contain_file("#{osfam}/bashrcdir/bash_completion.sh")
        end
      end#enable_git_completion false
    end#OSfam context
  end#osfam iterator
end
