# == Class: bashrc::svcstat
#  wrapper class
#Class['bashrc::svcstat']
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
  $bashrcdir = $bashrc::bashrcdir
  $enable    = $::bashrc::svcstat_enable
  $ini_hash  = $::bashrc::svcstat_ini_hash
  #
  if $enable {
    file {'bashrc::svcstat_conf':
      ensure  => 'file',
      mode    => '0444',
      path    =>  $configpath,
    }#end bashrc::svcstatd.conf file
    file{'bashrc::svcstat.py':
      ensure   => 'file',
      mode     => '0555',
      path     => "${binpath}/svcstat.py",
      source   => 'puppet://modules/bashrc/usr/local/bin/svcstat.py',
    }
    file{'bashrc::svcstat.sh':
      path    => "${bashrcdir}/svcstat.sh",
      content => "#!/bin/bash\r\npython ${binpath}/svcstat.py",
      mode    => '0555',
    }
    if $ini_hash {
      $default_attrs= {
        'path' => $configpath,
        'key_val_separator' => ',',
      }
      create_resources(ini_setting,$ini_hash,$default_attrs)
    }#end inihash if

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
