#  iTop Custom Extensions installation.
#
#  Valid for own created extenstions and TeemIP.
#
#  Requirements:   - Source file must be a zip file
#                  - Internal structure for the zip is:  web/extensions/<extension directory name>
#
define itop::extension (
  $version,
  $url,
  $target = '/usr/local/itop/extensions',
)
{
  archive { "${name}-${version}":
    ensure    => present,
    checksum  => true,
    extension => 'zip',
    url       => "${url}/${name}-${version}.zip",
    target    => $target,
  }
}
