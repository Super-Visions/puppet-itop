#  iTop Custom Extensions installation.
#
#  Valid for own created extenstions and TeemIP.
#
#  Requirements:   - Source file must be a zip file
#                  - Internal structure for the zip is:
#                                  web/extensions/<extension directory name>
#
class itop::extensions (
  $extension_hash = hiera('itop::extension_hash', {})
)
{
  #Class['itop::install'] -> Class['itop::extensions']

  validate_hash($extension_hash)
  if( $extension_hash )
  {
    create_resources( 'itop::extension', $extension_hash )
  }
}
