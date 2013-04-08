class itop::instance (
 docroot = hiera('itop::docroot')
) {

  cron { 'iTop_cron':
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params",
  }

}
