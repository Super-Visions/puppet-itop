#  iTop Custom Extensions installation.
#
#  Valid for own created extenstions and TeemIP.
#
#  Requirements:   - Source file must be a zip file
#                  - Internal structure for the zip is:
#                            web/extensions/<extension directory name>
#
define itop::resource::extension (
  $url        = hiera('itop::params::itop_url'),
  $target     = $itop::params::itop_ext_dir,
  $zip_target = $itop::params::itop_ext_zip_dir,
)
{
  archive { $name:
    ensure     => present,
    checksum   => true,
    extension  => 'zip',
    url        => "${url}/${name}.zip",
    target     => $target,
    src_target => $zip_target,
  }
}
