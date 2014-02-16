# == Class: bashrc::promptc
#
#This class manages the bashrc ps1.
# - colorification additios which will dynamically
# alter the colors of the user's prompt depending on Hiera parameters.
#
# - git branch awareness
#
# left variable block
#
# Seperator charater(s)
#
# right variable block
#
#
class bashrc::prompt {
  Class['bashrc::prompt'] -> Anchor['bashrc::config::end']
  include bashrc
  include bashrc::params
  $bashrcdir  = $bashrc::bashrcdir
  $git_prompt = $bashrc::prompt_git_enable
  case $::osfamily {
    #RedHat Debian Suse Solaris Windows
    RedHat, Debian: {
      file {"${bashrcdir}/prompt.sh":
        ensure  => file,
        owner   => '0',
        group   => '0',
        mode    => '0555',
        content => template("${module_name}/prompt.sh.erb"),
      }
      #git prompt enablement
      if $git_prompt {
        file {"${bashrcdir}/git-prompt.sh":
          ensure  => file,
          owner   => '0',
          group   => '0',
          mode    => '0555',
          source  => 'puppet:///modules/bashrc/etc/bashrc.d/git_prompt.sh',
        }
      }
    }#Supported OS case
    default: {
      notice "There is not currently a bashrc promptcolor module for ${::osfamily}"
    }#Unsupported OS case
  }
}#end of bashrc class
