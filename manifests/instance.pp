#
# Class itop::instance
#
define itop::instance (
  $installdir,
  $docroot,
  $user = 'apache',
  $group = 'apache',
  $extensions = [],
) {

  file { [ $installdir ]:
    ensure => directory,
    mode   => '0755',
  }

  exec { "iTop_install_${name}":
    command => "/usr/local/itop/bin/install_itop_site --root ${docroot} --user ${user} --group ${group}",
  }

  cron { "iTop_cron_${name}":
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params",
  }

  file { $docroot:
    ensure  => directory,
    mode    => '0644',
    recurse => true,
    require => Exec["iTop_install_${name}"],
  }

  file { [ "${docroot}/conf", "${docroot}/data", "${docroot}/env-production", "${docroot}/log" ]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    require => Exec["iTop_install_${name}"],
  }

}
