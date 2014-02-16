# == Class: bashrc
#
#This class manages the bashrc additions.
#
#Please see the README..md for
class bashrc(
  $bashrcdir              = $bashrc::params::bashrcdir,
  $enable_git_completion  = $bashrc::params::enable_git_completion,
  $enable_prompt_mods     = $bashrc::params::enable_prompt_mods,
  $etcbashfile            = $bashrc::params::etcbashfile,
  $prompt_color_enable    = $bashrc::params::prompt_color_enable,
  $prompt_git_color       = $bashrc::params::prompt_git_color,
  $prompt_git_enable      = $bashrc::params::prompt_git_enable,
  $prompt_leftblock       = $bashrc::params::prompt_leftblock,
  $prompt_primary_color   = $bashrc::params::prompt_primary,
  $prompt_rightblock      = $bashrc::params::prompt_rightblock,
  $prompt_secondary_color = $bashrc::params::prompt_secondary,
  $prompt_separator       = $bashrc::params::prompt_separator,
  $puppetdir              = $settings::confdir,
  $skelfile               = $bashrc::params::skelfile,
  )inherits bashrc::params {
  #input validation
  $supported_colors=['red','green','yellow','blue','purple','cyan','white']

  validate_absolute_path($bashrcdir)
  validate_absolute_path($etcbashfile)
  validate_absolute_path($skelfile)

  validate_bool($enable_git_completion)
  validate_bool($enable_prompt_mods)
  validate_bool($prompt_color_enable)
  validate_bool($prompt_git_enable)

  validate_re($prompt_primary_color,$supported_colors)
  validate_re($prompt_secondary_color,$supported_colors)
  if $prompt_git_enable {
    validate_re($prompt_git_color,$supported_colors)
  }

  validate_string($prompt_leftblock)
  validate_string($prompt_rightblock)
  validate_string($prompt_separator)

  anchor{'bashrc::begin':}
  -> anchor {'bashrc::config::begin':}
  -> anchor {'bashrc::config::end':}
  -> anchor {'bashrc::end':}

  case $::osfamily {
    #RedHat Debian Suse Solaris Windows
    'RedHat', 'Debian': {
      include bashrc::setup
      #prompt mods
      if $enable_prompt_mods == true {
        include bashrc::prompt
      }

      #bash_completion
      if $enable_git_completion {
        file {"${bashrcdir}/bash_completion.sh":
          ensure  => 'file',
          owner   => '0',
          group   => '0',
          mode    => '0555',
          source  => 'puppet:///modules/bashrc/etc/bashrc.d/git_completion.sh',
        }
      }

    }#Supported OS case
    default: {
      notice "There is not currently a bashrc module for ${::osfamily}"
    }#Unsupported OS case
  }#end case
}
