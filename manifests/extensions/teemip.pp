class itop::extensions::teemip( 
  $teemip_version = undef,
  $user = 'apache',
  $installdir = '/tmp',
  $docroot = hiera('itop::docroot', '/var/www/html')
) 
{

  package{ [ 'unzip' ]:
    ensure => installed,
  }

  file { [ "${installdir}/dl", "${installdir}/TeemIP-${teemip_version}", $docroot ]:
    ensure  => directory,
    owner   => $user,
  }

  if $teemip_version != '' {

    file{ "${installdir}/dl/TeemIp-Module-${teemip_version}.zip":
      ensure  => present,
      source => "/downloads/TeemIp-Module-${teemip_version}.zip",
      require => File["${installdir}/dl"],
    }

    exec{ 'unpack TeemIP':
      command => "unzip ${installdir}/dl/TeemIp-Module-${teemip_version}.zip",
      cwd     => "${installdir}/TeemIP-${teemip_version}/",
      subscribe => File["${installdir}/dl/TeemIp-Module-${teemip_version}.zip"],
      require => [Package["unzip"],File["${installdir}/TeemIP-${teemip_version}"],File["${installdir}/dl/TeemIp-Module-${teemip_version}.zip"]],
      refreshonly => true,
    }

    exec{ 'copy TeemIP':
      command   => "cp -Rp ${installdir}/TeemIP-${teemip_version}/web/* ${docroot}/",
      subscribe => Exec['unpack TeemIP'],
      refreshonly => true,
    }

    exec{ 'TeemIP extensions dir perms':
      command     => "find ${docroot}/extensions/ -type d -exec chmod 755 '{}' ';'",
      subscribe   => Exec['copy TeemIP'],
      refreshonly => true,
    }

    exec{ 'TeemIP extensions file perms':
      command     => "find ${docroot}/extensions/ -type f -exec chmod 644 '{}' ';'",
      subscribe   => Exec['copy TeemIP'],
      refreshonly => true,
    }
  }



}
