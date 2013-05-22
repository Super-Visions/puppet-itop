#
# Class itop::package
#
class itop::install::package(
  $ensure = present,
  $url = undef,
)
{

  #package{ [ "php${php_version}-mysql", "php${php_version}-soap", "php${php_version}-ldap"  ]:
  package{ [ 'php-mysql', 'php-soap', 'php-ldap'  ]:
    ensure => installed,
  }

  package{ [ 'php-domxml-php4-php5' ]:
    ensure => installed,
  }

  package{ [ 'php-mcrypt' ]:
    ensure => installed,
  }

  $source = "/downloads/iTop-${ensure}.noarch.rpm"

  package { 'iTop':
    ensure   => $ensure,
    source   => $source,
    provider => 'rpm',
  }
}
