class itop::extensions::custom ( 
  $custom_version = undef, 
  $user = 'apache',
  $installdir = '/tmp',
  $docroot = hiera('itop::docroot', '/var/www/html')
) 
{

  if $custom_version != '' {

    file{ "${installdir}/dl/custom-ext-${custom_version}.zip":
      ensure  => present,
      source => "/downloads/custom-ext-${custom_version}.zip",
      require => File["${installdir}/dl"],
    }

    exec{ 'unpack custom':
      command => "unzip ${installdir}/dl/custom-ext-${custom_version}.zip",
      cwd     => "${docroot}/extensions",
      require => [Package["unzip"],File["${docroot}"],File["${installdir}/dl/custom-ext-${custom_version}.zip"]],
    }

    exec{ 'custom extensions dir perms':
      command     => "find ${docroot}/extensions/ -type d -exec chmod 755 '{}' ';'",
      subscribe   => Exec['unpack custom'],
      refreshonly => true,
    }

    exec{ 'custom extensions file perms':
      command     => "find ${docroot}/extensions/ -type f -exec chmod 644 '{}' ';'",
      subscribe   => Exec['unpack custom'],
      refreshonly => true,
    }
  }

}
