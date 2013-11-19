#
# Class itop::install
#
class itop::install::zip (
  $ensure         = undef,
  $url            = undef,
  $base_src_dir   = undef,
  $php_version    = '',
  #$user           = 'apache',
  #$installdir     = '/var/www',
)
{
  $version = $ensure
  $srcdir = "${base_src_dir}/${version}"

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
    target    => "${srcdir}",
    root_dir  => 'web'
  }

  archive { 'toolkit-2.0':
    ensure    => present,
    checksum  => true,
    extension => 'zip',
    url       => "${url}/toolkit-2.0.zip",
    target    => "${srcdir}/web",
    root_dir  => 'toolkit',
    require   => Archive["iTop-${version}"]
  }

  file { "${base_src_dir}/bin":
    ensure    => directory,
    require   => Archive["iTop-${version}"]
  }
  file { "${base_src_dir}/bin/install_itop_site":
    ensure  => present,
    content => template('itop/install_itop_site'),
    mode    => '0750',
    require => File["${base_src_dir}/bin"]
  }

  file { "${srcdir}/web/toolkit/ajax.toolkit.php":
    ensure  => file,
    mode    => '0644',
    require => Archive['toolkit-2.0']
  }
  file { "${srcdir}/web/toolkit/index.php":
    ensure  => file,
    mode    => '0644',
    require => Archive['toolkit-2.0']
  }
  file { "${srcdir}/web/toolkit/toolkit.css":
    ensure  => file,
    mode    => '0644',
    require => Archive['toolkit-2.0']
  }



}
