# == Class: bashrc::svcstat
#  Enables or disables the deployment of svcstat.
#  Please see README.md for usage
#
class bashrc::svcstat(
  $binpath    = '/usr/local/bin/',
  $configpath = '/usr/local/etc/svcstat.conf',
  ) {
  Class['bashrc::svcstat'] -> Anchor['bashrc::config::end']
  validate_absolute_path($binpath)
  validate_absolute_path($configpath)
  #make our parameters local scope
  include bashrc
  include bashrc::params
  $bashrcdir     = $bashrc::bashrcdir
  $enable        = $bashrc::enable_svcstat
  $services_hash = $bashrc::svcstat_hash
  #
  if $enable {
    file{'bashrc::svcstat.py':
      ensure   => 'file',
      mode     => '0555',
      path     => "${binpath}/svcstat.py",
      source   => 'puppet:///modules/bashrc/usr/local/bin/svcstat.py',
    }
    file{'bashrc::svcstat.sh':
      path    => "${bashrcdir}/svcstat.sh",
      content => template("${module_name}/svcstat.sh.erb"),
      mode    => '0555',
    }
    if $services_hash {
      validate_hash($services_hash)
      file {'bashrc::svcstat_conf':
        ensure  => 'file',
        mode    => '0444',
        path    =>  $configpath,
        content => template("${module_name}/svcstat.conf.erb")
      }#end bashrc::svcstatd.conf file
    }#end hash if

  }#end should be present case
  else {
    file {'bashrc::svcstat_conf':
      ensure => 'absent',
      path   =>  $configpath,
    }#end bashrc::svcstat_conf file
    file {'bashrc::svcstat.sh':
      ensure => 'absent',
      path   => "${bashrcdir}/svcstat.sh",
    }#End bashrc::svcstat.sh file
    file {'bashrc::svcstat.py':
      ensure  => 'absent',
      path    => "${binpath}/svcstat.py",
    }#end bashrc::svcstat.py file
  }#end configfiles should be absent case
}#end class
