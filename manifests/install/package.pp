#
# Class itop::package
#
class itop::install::package(
  $version  = $itop::version,
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

  $source = "/downloads/iTop-${version}.noarch.rpm"

  package { 'iTop':
    ensure   => $version,
    source   => $source,
    provider => 'rpm',
  }
}
