class bashrc::params {
  $enable_git_completion = true
  $enable_prompt_color   = true
  $enable_prompt_mods    = true
  $enable_svcstat        = true
  $prompt_git_color      = 'yellow'
  $prompt_git_enable     = true
  $prompt_primary        = 'blue'
  $prompt_secondary      = 'white'
  $puppetdir             = $settings::confdir
  $purge_bashrcdir       = true

  case $::osfamily {
    #RedHat Debian Suse Solaris Windows
    Redhat: {
      $bashrcdir          = '/etc/profile.d'
      $skelfile           = '/etc/skel/.bashrc'
      $etcbashfile        = '/etc/bashrc'
      $prompt_leftblock   = '\u'
      $prompt_rightblock  = '\h \W'
      $prompt_separator   = '@'
    }#RHEL variants

    Debian: {
      $bashrcdir         = '/etc/profile.d'
      $skelfile          = '/etc/skel/.bashrc'
      $etcbashfile       =  '/etc/bash.bashrc'
      $prompt_leftblock  = '\u'
      $prompt_rightblock = '\h \W'
      $prompt_separator  = '@'
    }#debian variants

    Suse: {
      $bashrcdir         = '/etc/profile.d'
      $skelfile          = '/etc/skel/.bashrc'
      $etcbashfile       = '/etc/bash.bashrc.local'
      $prompt_leftblock  = '\u'
      $prompt_rightblock = '\h \W'
      $prompt_separator  = '@'
    }#SLES/SLED/OpenSuSE/SuSE

    default: {
      #Sane-ish values for other OSes
      $bashrcdir         = '/etc/profile.d'
      $etcbashfile       =  '/etc/bashrc'
      $prompt_leftblock  = '\u'
      $prompt_rightblock = '\h \W'
      $prompt_separator  = '@'
      $skelfile          = '/etc/skel/.bashrc'
    }#end default osfamily
  }#end case
}#end parameters class
