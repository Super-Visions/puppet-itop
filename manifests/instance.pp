#
# Class itop::instance
#
define itop::instance (
  $installdir,
  $docroot,
) {

  file { [ $installdir, $docroot ]:
    ensure => directory,
  }

  exec { "iTop_install_${name}":
    command => "/usr/local/itop/bin/install_itop_site --root ${docroot}",
  }

  cron { "iTop_cron_${name}":
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params",
  }

  file { [ "${installdir}/${name}", "${installdir}/${name}/dl", "${installdir}/${name}/Extra-Ext" ]:
    ensure  => directory,
  }

}
