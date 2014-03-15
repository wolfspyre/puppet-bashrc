# == Class: bashrc::setup
#
#This class manages the bashrc additions.
#
class bashrc::setup {
  Class['bashrc::setup'] -> Anchor['bashrc::config::end']
  File{} -> Anchor['bashrc::config::end']
  Exec{} -> Anchor['bashrc::config::end']
  $bashrcdir   = $bashrc::bashrcdir
  $etcbashfile = $bashrc::etcbashfile
  $skelfile    = $bashrc::skelfile
  file { $bashrcdir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0555',
    purge  => true,
  }#end directory
  file { $skelfile:
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
  }

  exec { 'bashrc_append':
    command => "/bin/echo 'for i in ${bashrcdir}/*.sh ; do . \$i >/dev/null 2>&1; done' >>${etcbashfile}",
    unless  => "/bin/grep -q \"bashrc.d/\\*.sh\" ${etcbashfile}",
  }
  case $::osfamily {
    Debian: {
      #we need to add sourcing of bashrc.d to /etc/bash_completion to accomodate users already existing.
      exec { 'bash_completion_append':
        command => "/bin/echo 'for i in ${bashrcdir}/*.sh ; do . \$i >/dev/null 2>&1; done' >>/etc/bash_completion",
        unless  => '/bin/grep -q "bashrc.d/\\*.sh" /etc/bash_completion',
      }
    }
    default: {
      #Make lint happy
    }
  }
}#end of bashrc::setup class