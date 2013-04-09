class itop::instance (
 $docroot = hiera('itop::docroot', '/var/www/html')
) {

  exec { '/usr/local/itop/bin/install_itop_site': }

  cron { 'iTop_cron':
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params",
  }

}
