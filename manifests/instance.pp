#
# Class itop::instance
#
define itop::instance (
  $installdir,
  $docroot,
  $user = 'apache',
  $group = 'apache',
) {

  file { [ $installdir, $docroot ]:
    ensure => directory,
  }

  exec { "iTop_install_${name}":
    command => "/usr/local/itop/bin/install_itop_site --root ${docroot} --user ${user} --group ${group}",
  }

  cron { "iTop_cron_${name}":
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params",
  }

  file { [ "${installdir}/${name}", "${installdir}/${name}/dl", "${installdir}/${name}/Extra-Ext" ]:
    ensure  => directory,
  }

  file { [ "${docroot}/conf", "${docroot}/data", "${docroot}/env-production", "${docroot}/log" ]:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0750',
  }

}
