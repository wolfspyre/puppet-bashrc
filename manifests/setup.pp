# == Class: bashrc::setup
#
#This class manages the bashrc additions.
#
class bashrc::setup {
  Class['bashrc::setup'] -> Anchor['bashrc::config::end']
  include bashrc #make our parameters local scope
  File{} -> Anchor['bashrc::config::end']
  Exec{} -> Anchor['bashrc::config::end']
  $bashrcdir   = $bashrc::bashrcdir
  $purge       = $bashrc::purge_bashrcdir
  $etcbashfile = $bashrc::etcbashfile
  file { $bashrcdir:
    ensure => directory,
    group  => 'root',
    mode   => '0555',
    owner  => 'root',
    purge  => $purge,
  }#end directory
  case $::osfamily {
    RedHat:  {}
    Debian:  {}
    Suse:    {}
    default: {}
  }
}#end of bashrc::setup class
