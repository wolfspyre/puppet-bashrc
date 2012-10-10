# == Class: bashrc::rhel
#
#This class manages the bashrc additions.
# === Authors
#
# Wolf Noble <wnoble@datapipe.com>
#
# === Copyright
#
# Copyright 2012 Datapipe, unless otherwise noted.
#
Class['bashrc::rhel'] -> Anchor['bashrc::config::end']
class bashrc::rhel {
  include bashrc::params #make our parameters local scope
  File{} -> Anchor['bashrc::config::end']
  Exec{} -> Anchor['bashrc::config::end']
  $bashrcdir  = $bashrc::params::bashrcdir
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

  exec { 'bashrc_append':
    command => "/bin/echo 'for i in ${bashrcdir}/*.sh ; do . \$i >/dev/null 2>&1; done' >>/etc/bashrc",
    unless  => '/bin/grep bashrc.d/\\*.sh /etc/bashrc',
  }
}#end of bashrc::rhel class
