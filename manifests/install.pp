#
# Class itop::install
#
class itop::install (
  $version        = '',
  $php_version    = '',
  $teemip_version = '',
  $user           = 'apache',
  $installdir     = '/var/www',
  $docroot        = '/var/www/html',
)
{
  #$installdir = '/usr/app/ApacheDomain/DomainITOP01ACC'
  #$docroot = '/usr/app/ApacheDomain/DomainITOP01ACC/htdocs'

  #$installdir = '/usr/app/itop'
  #$docroot = '/usr/app/itop/http'
  #$user = 'itop'

  #$php_version = '53'
  #$teemip_version = '1.0.a-4'

  package{ [ 'unzip' ]:
    ensure => installed,
  }

  # needed by iTopImport.pl script
  #package { ['perl-Time-HiRes']:
  #  ensure => installed,
  #}

  #package{ [ 'cronie' ]:
  #  ensure => installed,
  #}

  #package{ "php${php_version}":
  #  ensure => installed,
  #}
  # EPEL required for 'php-mcrypt', 'php-domxml-php4-php5'
  package{ [ "php${php_version}-mysql", "php${php_version}-soap", "php${php_version}-ldap"  ]:
    ensure => installed,
  }
  package{ [ 'php-domxml-php4-php5' ]:
    ensure => installed,
  }
  # Not available on EPEL EL 5
  #package{ [ "php-mcrypt" ]:
  #  ensure => installed,
  #}

  file { [ "${installdir}/dl","${installdir}/session", "${installdir}/itop-${version}", $docroot ]:
    ensure  => directory,
    owner   => $user,
  }

  file{ "${installdir}/dl/iTop-${version}.zip":
    ensure  => present,
    source  => "puppet:///modules/itop/iTop-${version}.zip",
    require => File["${installdir}/dl"],
  }


  file{ "${installdir}/dl/toolkit-2.0.zip":
    ensure  => present,
    source  => 'puppet:///modules/itop/toolkit-2.0.zip',
    require => File["${installdir}/dl"],
  }

  exec{ 'unpack iTop2':
    command     => "unzip ${installdir}/dl/iTop-${version}.zip",
    cwd         => "${installdir}/itop-${version}/",
    creates     => "${installdir}/itop-${version}/INSTALL",
    subscribe   => File["${installdir}/dl/iTop-${version}.zip"],
    refreshonly => true,
  }

  exec{ 'copy iTop2':
    command     => "cp -Rp ${installdir}/itop-${version}/web/* ${docroot}/",
    creates     => "${docroot}/index.php",
    subscribe   => Exec['unpack iTop2'],
    refreshonly => true,
  }

  file { ["${docroot}/setup", "${docroot}/conf", "${docroot}/data", "${docroot}/env-production", "${docroot}/log" ]:
    ensure  => directory,
    owner   => $user,
    require => Exec['copy iTop2'],
  }

  cron { 'iTop_cron':
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params",
  }

  if $teemip_version != '' {
    file{ "${installdir}/dl/teemip-module-${teemip_version}.zip":
      ensure  => present,
      source  => "puppet:///modules/itop/teemip-module-${teemip_version}.zip",
      require => File["${installdir}/dl"],
    }

    exec{ 'unpack teemip':
      command => "unzip ${installdir}/dl/teemip-module-${teemip_version}.zip",
      cwd     => "${docroot}/extensions",
      creates => "${docroot}/extensions/teemip-config-mgmt-adaptor/",
      require => [File[$docroot],File["${installdir}/dl/teemip-module-${teemip_version}.zip"]],
    }

    exec{ 'extensions dir perms':
      command     => "find ${docroot}/extensions/ -type d -exec chmod 755 '{}' ';'",
      subscribe   => Exec['unpack teemip'],
      refreshonly => true,
    }

    exec{ 'extensions file perms':
      command     => "find ${docroot}/extensions/ -type f -exec chmod 644 '{}' ';'",
      subscribe   => Exec['unpack teemip'],
      refreshonly => true,
    }
  }

  exec{ 'unpack toolkit':
    command => "unzip ${installdir}/dl/toolkit-2.0.zip",
    cwd     => $docroot,
    creates => "${docroot}/toolkit",
    require => [File[$docroot],File["${installdir}/dl/toolkit-2.0.zip"]],
  }

  exec{ 'webroot dir perms':
    command     => "find ${docroot} -type d -exec chmod 755 '{}' ';'",
    subscribe   => Exec['copy iTop2'],
    refreshonly => true,
  }

  exec{ 'webroot file perms':
    command     => "find ${docroot} -type f -exec chmod 644 '{}' ';'",
    subscribe   => Exec['copy iTop2'],
    refreshonly => true,
  }

  exec{ 'config file perms':
    command     => "chmod 444 ${docroot}/conf/production/config-itop.php",
    subscribe   => Exec['webroot file perms'],
    refreshonly => true,
  }
}
