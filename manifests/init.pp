# == Class: bashrc
#
#This class manages the bashrc additions.
#
#Please see the README..md for
class bashrc(
  $bashrcdir              = $bashrc::params::bashrcdir,
  $enable_git_completion  = $bashrc::params::enable_git_completion,
  $enable_prompt_color    = $bashrc::params::enable_prompt_color,
  $enable_prompt_mods     = $bashrc::params::enable_prompt_mods,
  $enable_svcstat         = $bashrc::params::enable_svcstat,
  $etcbashfile            = $bashrc::params::etcbashfile,
  $prompt_git_color       = $bashrc::params::prompt_git_color,
  $prompt_git_enable      = $bashrc::params::prompt_git_enable,
  $prompt_leftblock       = $bashrc::params::prompt_leftblock,
  $prompt_primary_color   = $bashrc::params::prompt_primary,
  $prompt_rightblock      = $bashrc::params::prompt_rightblock,
  $prompt_secondary_color = $bashrc::params::prompt_secondary,
  $prompt_separator       = $bashrc::params::prompt_separator,
  $puppetdir              = $settings::confdir,
  $purge_bashrcdir        = $bashrc::params::purge_bashrcdir,
  $svcstat_hash           = undef,
  )inherits bashrc::params {
  #input validation
  $supported_colors=['red','green','yellow','blue','purple','cyan','white']

  validate_absolute_path($bashrcdir)
  validate_absolute_path($etcbashfile)

  validate_bool($enable_git_completion)
  validate_bool($enable_prompt_color)
  validate_bool($enable_prompt_mods)
  validate_bool($enable_svcstat)
  validate_bool($prompt_git_enable)
  validate_bool($purge_bashrcdir)

  validate_re($prompt_primary_color,$supported_colors)
  validate_re($prompt_secondary_color,$supported_colors)
  if $prompt_git_enable {
    validate_re($prompt_git_color,$supported_colors)
  }

  validate_string($prompt_leftblock)
  validate_string($prompt_rightblock)
  validate_string($prompt_separator)

  if $svcstat_hash {
    validate_hash($svcstat_hash)
  }
  anchor{'bashrc::begin':}
  -> anchor {'bashrc::config::begin':}
  -> anchor {'bashrc::config::end':}
  -> anchor {'bashrc::end':}

  case $::osfamily {
    #RedHat Debian Suse Solaris Windows
    'RedHat', 'Debian', 'Suse': {
      include ::bashrc::setup
      #prompt mods
      if $enable_prompt_mods {
        include bashrc::prompt
      }

      #bash_completion
      if $enable_git_completion {
        file {"${bashrcdir}/bash_completion.sh":
          ensure  => 'file',
          owner   => '0',
          group   => '0',
          mode    => '0555',
          source  => 'puppet:///modules/bashrc/etc/profile.d/git_completion.sh',
        }
      }

      #svcstat
      include ::bashrc::svcstat

    }#Supported OS case
    default: {
      notice "There is not currently a bashrc module for ${::osfamily}"
    }#Unsupported OS case
  }#end case
}
