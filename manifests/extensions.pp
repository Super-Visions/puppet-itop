#  iTop Custom Extensions installation.
#
#  Valid for own created extenstions and TeemIP.
#
#  Requirements:   - Source file must be a zip file
#                  - Internal structure for the zip is:
#                                  web/extensions/<extension directory name>
#
class itop::extensions (
  $extension_hash = $itop::extension_hash,
  $extension_install_type   = $itop::extension_install_type,
  $base_src_dir   = $itop::base_src_dir,
  $git_target     = $itop::git_dir,
  $default_revision = undef,
)
{
  #Class['itop::install'] -> Class['itop::extensions']

  file { $git_target:
    ensure  => directory,
    require => File[$base_src_dir],
  }

  validate_hash($extension_hash)
  if( $extension_hash )
  {
    $defaults = {
      revision => $default_revision
    }
    create_resources( "itop::resource::extension_${extension_install_type}", $extension_hash, $defaults )
  }
}
