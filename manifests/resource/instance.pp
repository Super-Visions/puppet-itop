#
# Class itop::resource::instance
#
define itop::resource::instance (
  $installdir,
  $docroot,
  $user           = 'apache',
  $group          = 'apache',
  $extensions     = [],
  $install_mode   = undef,
  $db_server      = 'localhost',
  $db_user        = 'root',
  $db_passwd      = '',
  $db_name        = undef,
  $db_prefix      = '',
  $itop_url       = undef,
  $admin_account  = 'admin',
  $admin_pwd      = 'admin',
  $modules        = undef,
  $src_dir        = $itop::params::itop_src_dir,
) {

  file { [ $installdir ]:
    ensure  => directory,
    mode    => '0755',
    #recurse => true,
  }

  $ext_str = join($extensions, ',')

  exec { "iTop_install_${name}":
    command => "/usr/local/itop/bin/install_itop_site --root ${docroot} --source ${src_dir} --user ${user} --group ${group} --extensions ${ext_str}",
    unless  => "/usr/local/itop/bin/install_itop_site --check --root ${docroot} --source ${src_dir} --user ${user} --group ${group} --extensions ${ext_str}",
    require => File["${docroot}/extensions"],
  }

  cron { "iTop_cron_${name}":
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params &> /dev/null",
  }

  file { "${docroot}/toolkit/unattended-install.php":
    ensure  => present,
    mode    => '0644',
    source  => 'puppet:///modules/itop/unattended-install.php',
    require => Exec["iTop_install_${name}"],
  }

  if file_exists("${docroot}/conf/production/config-itop.php") == 1 {
    exec { "iTop_unattended_upgrade_${name}":
      command   => "php unattended-install.php --response_file=${docroot}/toolkit/itop-auto-install.xml --install=1",
      onlyif    => "grep upgrade ${docroot}/conf/production/config-itop.php",
      cwd       => "${docroot}/toolkit",
      creates   => "${docroot}/conf/production/config-itop.php",
      path      => '/usr/bin:/usr/sbin:/bin',
      user      => $user,
      require   => File["${docroot}/toolkit/unattended-install.php"],
      subscribe => [  Exec["iTop_install_${name}"],
                      File["${docroot}/toolkit/itop-auto-install.xml"],
      ],
    }
  }
  else {
    exec { "iTop_unattended_install_${name}":
      command   => "php unattended-install.php --response_file=${docroot}/toolkit/itop-auto-install.xml --install=1",
      cwd       => "${docroot}/toolkit",
      creates   => "${docroot}/conf/production/config-itop.php",
      user      => $user,
      path      => '/usr/bin:/usr/sbin:/bin',
      require   => File["${docroot}/toolkit/unattended-install.php"],
      subscribe => [  Exec["iTop_install_${name}"],
                      File["${docroot}/toolkit/itop-auto-install.xml"],
      ],
    }
  }

  #notify{"Docroot = ${docroot} with Install Mode = ${install_mode}":}

  file { "${docroot}/toolkit/itop-auto-install.xml":
    ensure  => present,
    mode    => '0644',
    content => template('itop/itop-auto-install.xml.erb'),
    require => file["${docroot}/toolkit/unattended-install.php"],
  }

  #file { $docroot:
    #ensure  => directory,
    #mode    => '0644',
    #recurse => true,
    #require => Exec["iTop_install_${name}"],
  #}

  file { [ "${docroot}/conf", "${docroot}/data", "${docroot}/env-production",
            "${docroot}/extensions", "${docroot}/log" ]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    require => File[$installdir],
    #recurse => true,
  }

}
