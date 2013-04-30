#  iTop Custom Extensions installation.
#
#  Valid for own created extenstions and TeemIP.
#
#  Requirements:   - Source file must be a zip file
#                  - Internal structure for the zip is:  web/extensions/<extension directory name>
#
define itop::extensions::custom (
  $version,
  $package    = 'custom-ext',
  $user       = 'apache',
  $installdir = '/tmp',
  $docroot    = hiera('itop::docroot', '/var/www/html')
)
{

  file { [ "${installdir}/Extra-Ext/${package}", ]:
    ensure        => directory,
    owner         => $user,
  }

  file{ "${installdir}/dl/${package}-${version}.zip":
    ensure        => present,
    source        => "/downloads/${package}-${version}.zip",
    require       => File["${installdir}/dl"],
  }

  exec{ "unpack extension ${package}":
    command       => "unzip -u ${installdir}/dl/${package}-${version}.zip",
    cwd           => "${installdir}/Extra-Ext/${package}/",
    subscribe     => File["${installdir}/dl/${package}-${version}.zip"],
    require       => [Package['unzip'],File["${installdir}/Extra-Ext/${package}"],File["${installdir}/dl/${package}-${version}.zip"]],
    refreshonly   => true,
  }

  exec{ "copy ${package} Extensions":
    command       => "cp -Rp ${installdir}/Extra-Ext/${package}/web/* ${docroot}/",
    subscribe     => Exec["unpack extension ${package}"],
    refreshonly   => true,
  }

  exec{ "${package} extensions dir perms":
    command       => "find ${docroot}/extensions/ -type d -exec chmod 755 '{}' ';'",
    subscribe     => Exec["copy ${package} Extensions"],
    refreshonly   => true,
  }

  exec{ "${package} extensions file perms":
    command       => "find ${docroot}/extensions/ -type f -exec chmod 644 '{}' ';'",
    subscribe     => Exec["copy ${package} Extensions"],
    refreshonly   => true,
  }

}
