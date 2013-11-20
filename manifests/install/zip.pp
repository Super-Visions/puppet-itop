#
# Class itop::install
#
class itop::install::zip (
  $version        = itop::params::itop_version,
  $url            = itop::params::itop_url,
  $base_src_dir   = itop::params::itop_base_src_dir,
  $src_dir        = itop::params::itop_src_dir,
  $bin_dir        = itop::params::itop_bin_dir,
  $php_version    = ''
) inherits itop::params {

#  $srcdir = "${base_src_dir}/${version}"

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
    target    => $src_dir,
    root_dir  => 'web'
  }

  archive { 'toolkit-2.0':
    ensure    => present,
    checksum  => true,
    extension => 'zip',
    url       => "${url}/toolkit-2.0.zip",
    target    => "${src_dir}/web",
    root_dir  => 'toolkit',
    require   => Archive["iTop-${version}"]
  }

  file { $bin_dir:
    ensure    => directory,
    require   => Archive["iTop-${version}"]
  }
  file { "${bin_dir}/install_itop_site":
    ensure  => present,
    content => template('itop/install_itop_site'),
    mode    => '0750',
    require => File[$bin_dir]
  }

  file { "${src_dir}/web/toolkit/ajax.toolkit.php":
    ensure  => file,
    mode    => '0644',
    require => Archive['toolkit-2.0']
  }
  file { "${src_dir}/web/toolkit/index.php":
    ensure  => file,
    mode    => '0644',
    require => Archive['toolkit-2.0']
  }
  file { "${src_dir}/web/toolkit/toolkit.css":
    ensure  => file,
    mode    => '0644',
    require => Archive['toolkit-2.0']
  }

}
