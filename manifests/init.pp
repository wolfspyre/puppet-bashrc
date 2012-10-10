# == Class: bashrc
#
#This class manages the bashrc additions. 
# 
#At Present this consists of a module to dynamically alter the colors of the
#user's prompt depending on Hiera parameters.   
#  Curently only for rhel variants
#
# === Parameters
#
#bashrc::params::
#
#
#bashrc::params::bashrcdir
#  Sets the location of the to be created rc directory
#
#bashrc::params::prompt_color_enable
#  Whether or not to enable the colorization of the shell prompt
#
#bashrc::params::prompt_primary_color
#  What color the first colorized portion of the prompt should be
#
#bashrc::params::prompt_secondary_color
#  What color the second colorized portion of the prompt should be
#
#bashrc::params::puppetdir
#  sets where puppet is installed by default. Necessary for template switcher via an inline template
#
#bashrc::params::skelfile
#  Sets the location of the skeleton .bashrc file for new users
#
# === Variables
#
# Hiera varibles example.
#
#bashrc_prompt_color_enable:    'enabled'
#bashrc_prompt_primary_color:   'blue'
#bashrc_prompt_secondary_color: 'red'
#bashrc_prompt_pci_switch:       false
#
# === Examples
#
#  class { bashrc:
#  }
#
# === Authors
#
# Wolf Noble <wnoble@datapipe.com>
#
# === Copyright
#
# Copyright 2012 Datapipe, unless otherwise noted.
#
Anchor['dpcore::end'] -> Anchor['bashrc::begin']
class bashrc {
    #take advantage of the Anchor pattern
  anchor{'bashrc::begin':}
  -> anchor {'bashrc::config::begin':}
  -> anchor {'bashrc::config::end':}
  -> anchor {'bashrc::end':}
  class { 'bashrc::params': hiera_enabled => $::hiera_enabled }
  $bashrcdir = $bashrc::params::bashrcdir
  case $::osfamily {
    #RedHat Debian Suse Solaris Windows
    RedHat: {
      include bashrc::rhel
    }#end RHEL variant case
    default: {
      notice "There is not currently a bashrc module for $::osfamily"
    }#end default unsupported OS case
  }
}#end of bashrc class
