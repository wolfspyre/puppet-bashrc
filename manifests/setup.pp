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

  exec { 'bashrc_append':
    command => "/bin/echo 'for i in ${bashrcdir}/*.sh ; do . \$i >/dev/null 2>&1; done' >>${etcbashfile}",
    unless  => "/bin/grep bashrc.d/\\*.sh ${etcbashfile}",
  }
  case $::osfamily {
    Debian: {
      #we need to add sourcing of bashrc.d to /etc/bash_completion to accomodate users already existing.
      exec{ 'etc_bash_completion_append':
        command => "/bin/echo 'for i in ${bashrcdir}/*.sh ; do . \$i >/dev/null 2>&1; done' >>/etc/bash_completion",
        unless  => '/bin/grep bashrc.d/\\*.sh /etc/bash_completion',
      }
      #We also need to do this to /usr/share/bash-completion/bash_completion
      exec{'usr_share_bash_completion_append':
        command => "/bin/echo 'for i in ${bashrcdir}/*.sh ; do . \$i >/dev/null 2>&1; done' >>/usr/share/bash-completion/bash_completion",
        unless  => '/bin/grep bashrc.d/\\*.sh /usr/share/bash-completion/bash_completion',
      }
      exec{'debuntu_roots_bashrc':
        command => "/bin/echo 'for i in ${bashrcdir}/*.sh ; do . \$i >/dev/null 2>&1; done' >>/root/.bashrc",
        unless  => '/bin/grep bashrc.d/\\*.sh /root/.bashrc',
      }
    }
  }
}#end of bashrc::setup class
