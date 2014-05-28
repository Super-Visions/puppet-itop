#
# Class itop::resource::instance
#
define itop::resource::instance (
  $installroot     = $itop::installroot,
  $user               = 'apache',
  $group              = 'apache',
  $extensions         = {},
  $default_extensions = [],
  $install_mode       = undef,
  $db_server          = 'localhost',
  $db_user            = 'root',
  $db_passwd          = '',
  $db_name            = undef,
  $db_prefix          = '',
  $itop_url           = undef,
  $admin_account      = 'admin',
  $admin_pwd          = 'admin',
  $modules            = undef,
  $src_dir            = $itop::src_dir,
  $default_revision   = undef,
  $extension_install_type = $itop::extension_install_type,
)
{

  file { [ "${installroot}/${name}" ]:
    ensure  => directory,
    mode    => '0755',
  }

  file { [ "${installroot}/${name}/session", "${installroot}/${name}/http" ]:
    ensure  => directory,
    mode    => '0750',
    owner   => $user,
    group   => $group,
  }

  $docroot = "${installroot}/${name}/http"

  #$ext_str = join($extensions, ',')
  $ext_str = ''

  exec { "iTop_install_${name}":
    command => "/usr/local/itop/bin/install_itop_site --root ${docroot} --source ${src_dir} --user ${user} --group ${group} --extensions ${ext_str}",
    unless  => "/usr/local/itop/bin/install_itop_site --check --root ${docroot} --source ${src_dir} --user ${user} --group ${group} --extensions ${ext_str}",
    require => File["${docroot}/extensions"],
  }

  cron { "iTop_cron_${name}":
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params &> /dev/null",
  }

  file { [ "${docroot}/conf", "${docroot}/data", "${docroot}/env-production",
            "${docroot}/extensions", "${docroot}/log" ]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    require => File[$docroot],
  }

  # If extension install type = git
  # Manage vcsrepo's directly here
  case $extension_install_type {
    git: {
      class { 'itop::resource::extensions_git':
        extensions => $extensions,
        docroot    => $docroot,
        default_revision => $default_revision,
        require => Exec["iTop_install_${name}"],
      }
    }
    default: {}
  }

  file { "${docroot}/toolkit/unattended-install.php":
    ensure  => present,
    mode    => '0644',
    source  => 'puppet:///modules/itop/unattended-install.php',
    require => Exec["iTop_install_${name}"],
  }

  file { "${docroot}/webservices/export-simpleclient.php":
    ensure  => link,
    target  => "${docroot}/webservices/export.php",
    require => Exec["iTop_install_${name}"],
  }

  file { "${docroot}/webservices/rest-simpleclient.php":
    ensure  => link,
    target  => "${docroot}/webservices/rest.php",
    require => Exec["iTop_install_${name}"],
  }

  $configfile = "${docroot}/conf/production/config-itop.php"
  $responsefile = "${docroot}/toolkit/itop-auto-install.xml"

  file { $responsefile:
    ensure  => present,
    mode    => '0644',
    content => template('itop/itop-auto-install.xml.erb'),
    require => File["${docroot}/toolkit/unattended-install.php"],
  }

  case $install_mode {
    'upgrade': {
      $creates = undef
      $run_installer = true
    }
    'install': {
      $creates = "${docroot}/conf/production/config-itop.php"
      $run_installer = true
    }
    'manual': { }
    '': {}
    default: { fail("Unrecognized Install Mode: ${install_mode}") }
  }

  if $run_installer {

    exec { "iTop_unattended_install_${name}":
      command   => "chmod a+w ${configfile}; php unattended-install.php --response_file=${responsefile} --install=1",
      logoutput => true,
      cwd       => "${docroot}/toolkit",
      creates   => $creates,
      user      => $user,
      #require   => File[$responsefile],
      subscribe => [  Exec["iTop_install_${name}"],
                      File[$responsefile],
                      Class["Itop::Resource::Extensions_${extension_install_type}"],
      ],
      notify      => Service['httpd'],
    }

  }

  # case $install_mode {
  #   'upgrade': {
  #     $prev_conf_file = $configfile
  #
  #     exec { "iTop_unattended_upgrade_${name}":
  #       command     => "chmod a+w ${configfile}; php unattended-install.php --response_file=${responsefile} --install=1",
  #       #onlyif      => [  "test -e ${configfile}",
  #       #],
  #       logoutput   => true,
  #       cwd         => "${docroot}/toolkit",
  #       path        => '/usr/bin:/usr/sbin:/bin',
  #       user        => $user,
  #       refreshonly => true,
  #       require     => File["${docroot}/toolkit/unattended-install.php"],
  #       subscribe   => [  Exec["iTop_install_${name}"],
  #                         File["${docroot}/toolkit/itop-auto-install.xml"],
  #       ],
  #       notify      => Service['httpd'],
  #     }
  #   }
  #   'install': {
  #     $prev_conf_file = ''
  #
  #     exec { "iTop_unattended_install_${name}":
  #       command   => "php unattended-install.php --response_file=${responsefile} --install=1",
  #       logoutput => true,
  #       cwd       => "${docroot}/toolkit",
  #       creates   => "${docroot}/conf/production/config-itop.php",
  #       user      => $user,
  #       require   => File["${docroot}/toolkit/unattended-install.php"],
  #       subscribe => [  Exec["iTop_install_${name}"],
  #                       File["${docroot}/toolkit/itop-auto-install.xml"],
  #       ],
  #       notify      => Service['httpd'],
  #     }
  #   }
  #   'manual': { }
  #   '': {}
  #   default: { fail("Unrecognized Install Mode: ${install_mode}") }
  # }

  #notify{"Docroot = ${docroot} with Install Mode = ${install_mode} and Config File ${configfile}":}

  #file { "${docroot}/toolkit/itop-auto-install.xml":
  #  ensure  => present,
  #  mode    => '0644',
  #  content => template('itop/itop-auto-install.xml.erb'),
  #  require => file["${docroot}/toolkit/unattended-install.php"],
  #}

}
