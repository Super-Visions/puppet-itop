class itop::resource::extensions_git (
  $extensions,
  $docroot,
  $default_revision,
)
{

  validate_hash($extensions)
  if( $extensions )
  {
    $defaults = {}
    $defaults['revision'] = $default_revision
    $defaults['ext_dir'] = "$docroot/extensions"
    create_resources( "itop::resource::extension_git", $extensions, $defaults )
  }
}
