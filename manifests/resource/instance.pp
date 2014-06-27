#
# Class itop::resource::instance
#
define itop::resource::instance (
  $installroot     = $itop::installroot,
  $user               = 'apache',
  $group              = 'apache',
  $extensions         = {},
  $default_extensions = [],
  $extension_config   = {},
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
  $allowed_login_types    = undef,
)
{

  $docroot = "${installroot}/${name}/http"

  $responsefile_install = "${docroot}/toolkit/itop-auto-install.xml"
  $responsefile_upgrade = "${docroot}/toolkit/itop-auto-upgrade.xml"
  $configfile = "${docroot}/conf/production/config-itop.php"
  $template_configfile = "${docroot}/conf/template-production-config-itop.php"

  $prev_conf_file = $install_mode? {
    'upgrade' => $template_configfile,
    'install' => $template_configfile,
  }

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

  #$ext_str = join($extensions, ',')
  $ext_str = ''

  exec { "iTop_install_${name}":
    command => "/usr/local/itop/bin/install_itop_site --root ${docroot} --source ${src_dir} --user ${user} --group ${group} --extensions ${ext_str}",
    unless  => "/usr/local/itop/bin/install_itop_site --check --root ${docroot} --source ${src_dir} --user ${user} --group ${group} --extensions ${ext_str}",
    require => File["${docroot}/extensions"],
  }

  cron { "iTop_cron_${name}":
    ensure  => present,
    command => "su - ${user} -c '/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params &> /dev/null'",
    minute  => '*/5',
  }

  # cron { "iTop_cron_${name}_${user}":
  #   command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params &> /dev/null",
  #   user    => $user,
  #   minute  => '*/5',
  # }

  file { [ "${docroot}/conf", "${docroot}/data", "${docroot}/env-production",
            "${docroot}/extensions", "${docroot}/log" ]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    require => File[$docroot],
  }

  concat { "${name}_itop_template_configfile":
    path  => "${template_configfile}",
    owner => $user,
    group => $group,
    mode  => '0640'
  }

  concat::fragment{ "${name}_config_template_header":
    target  => "${name}_itop_template_configfile",
    content => template("itop/config_itop/001_header.php.erb"),
    order   => '001',
  }

  concat::fragment{ "${name}_config_template_settings":
    target  => "${name}_itop_template_configfile",
    content => template("itop/config_itop/010_mysettings.php.erb"),
    order   => '010',
  }

  concat::fragment{ "${name}_config_template_mymodulesettings_header":
    target  => "${name}_itop_template_configfile",
    content => template("itop/config_itop/100_mymodulesettings_header.php.erb"),
    order   => '100',
  }

  concat::fragment{ "${name}_config_template_mymodulesettings_footer":
    target  => "${name}_itop_template_configfile",
    content => template("itop/config_itop/900_mymodulesettings_footer.php.erb"),
    order   => '900',
  }

  concat::fragment{ "${name}_config_template_mymodules":
    target  => "${name}_itop_template_configfile",
    content => template("itop/config_itop/990_mymodules.php.erb"),
    order   => '990',
  }

  concat::fragment{ "${name}_config_template_footer":
    target  => "${name}_itop_template_configfile",
    content => template("itop/config_itop/999_footer.php.erb"),
    order   => '999',
  }

  # If extension install type = git
  # Manage vcsrepo's directly here
  case $extension_install_type {
    git: {
      itop::resource::extensions_git { $name:
        extensions => $extensions,
        docroot    => $docroot,
        default_revision => $default_revision,
        user => $user,
        require => Exec["iTop_install_${name}"],
      }
    }
    default: {}
  }

  # cron { "iTop_cron_${name}_${user}":
  #   command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params &> /dev/null",
  #   user    => $user,
  #   minute  => '*/5',
  # }

  file { "${docroot}/toolkit/unattended-install.php":
    ensure  => present,
    mode    => '0644',
    source  => 'puppet:///modules/itop/unattended-install.php',
    require => Exec["iTop_install_${name}"],
    owner   => $user,
    group   => $group,
  }

  file { "${docroot}/webservices/export-simpleclient.php":
    ensure  => link,
    target  => "${docroot}/webservices/export.php",
    require => Exec["iTop_install_${name}"],
    owner   => $user,
    group   => $group,
  }

  file { "${docroot}/webservices/rest-simpleclient.php":
    ensure  => link,
    target  => "${docroot}/webservices/rest.php",
    require => Exec["iTop_install_${name}"],
    owner   => $user,
    group   => $group,
  }

  file { $responsefile_install:
    ensure  => present,
    mode    => '0644',
    content => template('itop/itop-auto-install.xml.erb'),
    require => File["${docroot}/toolkit/unattended-install.php"],
    owner   => $user,
    group   => $group,
  }

  file { $responsefile_upgrade:
    ensure  => present,
    mode    => '0644',
    content => template('itop/itop-auto-upgrade.xml.erb'),
    require => File["${docroot}/toolkit/unattended-install.php"],
    owner   => $user,
    group   => $group,
  }

  # php unattended-install.php --response_file=<path to the XML response file> [--install=1] [--clean=1]
  # The options are:
  # --install=1 to perform the installation
  # --clean=1 to erase the config file and the database before doing the installation (useful for testing the installations several times in a row)

  case $install_mode {
    'upgrade': {
      exec { "iTop_unattended_upgrade_${name}":
        command     => "chmod a+w ${configfile}; php unattended-install.php --response_file=${responsefile_upgrade} --install=1",
        logoutput   => true,
        cwd         => "${docroot}/toolkit",
        user        => $user,
        refreshonly => true,
        timeout     => 1200,
        subscribe   => [
                          Exec["iTop_install_${name}"],
                          File[$responsefile_upgrade],
                          File["${template_configfile}"],
                          Itop::Resource::Extensions_git[$name],
                       ],
      }
    }
    'install': {
      $creates = "${docroot}/conf/production/config-itop.php"
      exec { "iTop_unattended_install_${name}":
        command     => "chmod a+w ${configfile}; php unattended-install.php --response_file=${responsefile_install} --install=1",
        logoutput   => true,
        cwd         => "${docroot}/toolkit",
        creates     => $creates,
        user        => $user,
        refreshonly => true,
        timeout     => 1200,
        subscribe   => [
                          Exec["iTop_install_${name}"],
                          File[$responsefile_install],
                          File["${template_configfile}"],
                          Itop::Resource::Extensions_git[$name],
                       ],
      }
      exec { "iTop_unattended_install_upgrade_${name}":
        command     => "chmod a+w ${configfile}; php unattended-install.php --response_file=${responsefile_upgrade} --install=1",
        logoutput   => true,
        cwd         => "${docroot}/toolkit",
        user        => $user,
        refreshonly => true,
        timeout     => 1200,
        subscribe   => [
                          Exec["iTop_unattended_install_${name}"],
                          File[$responsefile_upgrade],
                          File["${template_configfile}"],
                          Itop::Resource::Extensions_git[$name],
                       ],
      }
    }
    'manual': { }
    default: { fail("Unrecognized Install Mode: ${install_mode}") }
  }
}
