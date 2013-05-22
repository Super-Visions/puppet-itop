#
# Class itop::install
#
class itop::install::zip (
  $ensure,
  $url,
  $php_version    = '',
  $user           = 'apache',
  $installdir     = '/var/www',
  $docroot        = '/var/www/html',
)
{

  $version = $ensure

  Package['unzip'] -> Class['itop::install::zip']

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

  file { [ "${installdir}/dl","${installdir}/session", "${installdir}/itop-${version}" ]:
    ensure  => directory,
    owner   => $user,
  }

  archive { "iTop-${version}":
    ensure    => present,
    checksum  => false,
    extension => 'zip',
    url       => "${url}/iTop-${version}.zip",
    target    => "/usr/local/itop",
    #target    => "${installdir}/dl/iTop-${version}",
  }

  archive { "toolkit-2.0":
    ensure    => present,
    checksum  => false,
    extension => 'zip',
    url       => "${url}/toolkit-2.0.zip",
    target    => "/usr/local/itop",
    #target    => "${installdir}/dl/toolkit-2.0",
  }

#  exec{ 'copy iTop2':
#    command     => "cp -Rp ${installdir}/itop-${version}/web/* ${docroot}/",
#    creates     => "${docroot}/index.php",
#    subscribe   => Exec['unpack iTop2'],
#    refreshonly => true,
#  }
#
#  file { ["${docroot}/setup", "${docroot}/conf", "${docroot}/data", "${docroot}/env-production", "${docroot}/log" ]:
#    ensure  => directory,
#    owner   => $user,
#    require => Exec['copy iTop2'],
#  }
#
#  cron { 'iTop_cron':
#    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params",
#  }
#
#  #exec{ 'unpack toolkit':
#  #  command => "unzip ${installdir}/dl/toolkit-2.0.zip",
#  #  cwd     => $docroot,
#  #  creates => "${docroot}/toolkit",
#  #  require => [File[$docroot],File["${installdir}/dl/toolkit-2.0.zip"]],
#  #}
#
#  exec{ 'webroot dir perms':
#    command     => "find ${docroot} -type d -exec chmod 755 '{}' ';'",
#    subscribe   => Exec['copy iTop2'],
#    refreshonly => true,
#  }
#
#  exec{ 'webroot file perms':
#    command     => "find ${docroot} -type f -exec chmod 644 '{}' ';'",
#    subscribe   => Exec['copy iTop2'],
#    refreshonly => true,
#  }
#
#  exec{ 'config file perms':
#    command     => "chmod 444 ${docroot}/conf/production/config-itop.php",
#    subscribe   => Exec['webroot file perms'],
#    refreshonly => true,
#  }
}
