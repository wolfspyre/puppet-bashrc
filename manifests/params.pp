class bashrc::params($hiera_enabled=false) {
  $puppetdir = $settings::confdir
  #this is disabled for the time being
  $prompt_pci_switch = false
  case $::osfamily {
    #RedHat Debian Suse Solaris Windows
    Redhat: {
      $bashrcdir  = '/etc/bashrc.d'
      $skelfile   = '/etc/skel/.bashrc'
    }#end RHEL variants
    default: {
      #Sane-ish values for other OSes
      $bashrcdir  = '/etc/bashrc.d'
      $skelfile   = '/etc/skel/.bashrc'
    }#end default osfamily
  }#end osfamily switch
  if $hiera_enabled {
    $prompt_color_enable    = hiera('bashrc_prompt_color_enable',     true   )
    $prompt_primary         = hiera('bashrc_prompt_primary_color',   'blue'  )
    $prompt_secondary       = hiera('bashrc_prompt_secondary_color', 'white' )
    #$prompt_pci_switch    = hiera('bashrc_prompt_pci_switch',   false  )
  }#end withhiera case

  else {
    $prompt_color_enable  =  true
    $prompt_primary       = 'blue'
    $prompt_secondary     = 'white'
    #$prompt_pci_switch    =  false
  }#end nohiera case
  #sanitize
  case $prompt_primary {
    #sanitize input
    red,green,yellow,blue,purple,cyan,white: {
      $prompt_primary_color = $prompt_primary
    }# good.
    default: {
      notice "primary prompt color ${prompt_primary} is invalid for ${::fqdn}. setting to sane default."
      $prompt_primary_color = 'blue'
    }#end default
  }#end prompt_primary sanitization
  case $prompt_secondary {
    #sanitize input
    red,green,yellow,blue,purple,cyan,white: {
      $prompt_secondary_color = $prompt_secondary
    }# good.
    default: {
      notice "secondary prompt color ${prompt_secondary} is invalid for ${::fqdn}. setting to sane default."
      $prompt_secondary_color = 'white'
    }#end default
  }#end prompt_primary sanitization
}#end parameters class
