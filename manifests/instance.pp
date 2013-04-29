class itop::instance (
 $installdir = '/tmp',
 $docroot = hiera('itop::docroot', '/var/www/html')
) {

  exec { '/usr/local/itop/bin/install_itop_site': }

  cron { 'iTop_cron':
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params",
  }

  file { [ "${installdir}/dl", "${installdir}/Extra-Ext", $docroot ]:
    ensure  => directory,
    owner   => $user,
  }

}
