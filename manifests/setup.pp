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
  $etcbashfile = $bashrc::etcbashfile
  file { $bashrcdir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0555',
    purge  => true,
  }#end directory
  file { '/etc/skel/.bashrc':
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
  }
  case $::osfamily {
    RedHat: {}
    Debian: {}
    Default: {}
  }
}#end of bashrc::setup class
