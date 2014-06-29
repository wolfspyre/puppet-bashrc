class bashrc::params {
  $puppetdir             = $settings::confdir
  $enable_git_completion = true
  $enable_prompt_mods    = true
  $enable_svcstat        = true
  $prompt_color_enable   = true
  $prompt_git_color      = 'yellow'
  $prompt_git_enable     = true
  $prompt_primary        = 'blue'
  $prompt_secondary      = 'white'

  case $::osfamily {
    #RedHat Debian Suse Solaris Windows
    Redhat: {
      $bashrcdir          = '/etc/bashrc.d'
      $skelfile           = '/etc/skel/.bashrc'
      $etcbashfile        = '/etc/bashrc'
      $prompt_leftblock   = '\u'
      $prompt_rightblock  = '\h \W'
      $prompt_separator   = '@'
    }#RHEL variants

    Debian: {
      $bashrcdir         = '/etc/bashrc.d'
      $skelfile          = '/etc/skel/.bashrc'
      $etcbashfile       =  '/etc/bash.bashrc'
      $prompt_leftblock  = '\u'
      $prompt_rightblock = '\h \W'
      $prompt_separator  = '@'
    }#debian variants

    default: {
      #Sane-ish values for other OSes
      $bashrcdir         = '/etc/bashrc.d'
      $skelfile          = '/etc/skel/.bashrc'
      $prompt_leftblock  = '\u'
      $prompt_rightblock = '\h \W'
      $prompt_separator  = '@'
    }#end default osfamily
  }#end case
}#end parameters class
