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

  file_line { 'bashrc_append':
    line   => "for i in ${bashrcdir}/*.sh ; do . \$i >/dev/null 2>&1; done",
    ensure => present,
    path   => "${etcbashfile}",
  }
  
  case $::osfamily {
    Debian: {
      #we need to add sourcing of bashrc.d to /etc/bash_completion to accomodate users already existing.
      exec { 'bash_completion_append':
        command => "/bin/echo 'for i in ${bashrcdir}/*.sh ; do . \$i >/dev/null 2>&1; done' >>/etc/bash_completion",
        unless  => '/bin/grep bashrc.d/\\*.sh /etc/bash_completion',
      }
    }
  }
}#end of bashrc::setup class
