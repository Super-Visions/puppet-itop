#
# Class itop::install
#
class itop::install::zip (
  $ensure,
  $url,
  $php_version    = '',
  #$user           = 'apache',
  #$installdir     = '/var/www',
)
{
  $version = $ensure

  Package['unzip'] -> Class['itop::install::zip']

  # EPEL required for 'php-mcrypt', 'php-domxml-php4-php5'
#  package{ [ "php${php_version}-mysql", "php${php_version}-soap", "php${php_version}-ldap"  ]:
#    ensure => installed,
#  }
#  package{ [ 'php-domxml-php4-php5' ]:
#    ensure => installed,
#  }

  # Not available on EPEL EL 5
  #package{ [ "php-mcrypt" ]:
  #  ensure => installed,
  #}

  #file { [ "${installdir}/dl","${installdir}/session", "${installdir}/itop-${version}" ]:
  #  ensure  => directory,
  #  owner   => $user,
  #}

  archive { "iTop-${version}":
    ensure    => present,
    checksum  => true,
    extension => 'zip',
    url       => "${url}/iTop-${version}.zip",
    target    => '/usr/local/itop',
    root_dir  => 'web'
  }

  archive { 'toolkit-2.0':
    ensure    => present,
    checksum  => true,
    extension => 'zip',
    url       => "${url}/toolkit-2.0.zip",
    target    => '/usr/local/itop/web',
    root_dir  => 'toolkit',
    require   => Archive["iTop-${version}"]
  }

  file { '/usr/local/itop/bin':
    ensure    => directory,
    require   => Archive["iTop-${version}"]
  }
  file { '/usr/local/itop/bin/install_itop_site':
    ensure  => present,
    content => template('itop/install_itop_site'),
    mode    => '0750',
    require => File['/usr/local/itop/bin']
  }

}
