# == Class: bashrc::promptcolor
#
#This class manages the bashrc colorification addition which will dynamically
#alter the colors of the user's prompt depending on Hiera parameters.   
#  Curently only for rhel variants
#
#See init.pp for parameters
#
# === Authors
#
# Wolf Noble <wnoble@datapipe.com>
#
# === Copyright
#
# Copyright 2012 Datapipe, unless otherwise noted.
#
Class['bashrc::promptcolor'] -> Anchor['bashrc::config::end']
class bashrc::promptcolor {
  include bashrc
  include bashrc::params
  $bashrcdir = $bashrc::params::bashrcdir
  case $::osfamily {
    #RedHat Debian Suse Solaris Windows
    RedHat: {
      include bashrc::rhel
      file {'/etc/bashrc.d/promptcolor.sh':
        ensure  => file,
        owner   => '0',
        group   => '0',
        mode    => '0555',
        content => template("${module_name}/promptcolor.sh.erb"),
      }
    }#end RHEL variant case
    default: {
      notice "There is not currently a bashrc promptcolor module for $::osfamily"
    }#end default unsupported OS case
  }
}#end of bashrc class
