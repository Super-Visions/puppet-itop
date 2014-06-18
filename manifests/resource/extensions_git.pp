define itop::resource::extensions_git (
  $extensions,
  $docroot,
  $default_revision,
)
{

  validate_hash($extensions)
  if( $extensions )
  {
    $prefixed_extensions = prefix_hash_keys( $extensions, "${name}_" )

    $defaults = {
      instance_name => $name,
      revision => $default_revision,
      ext_dir  => "$docroot/extensions",
    }
    create_resources( "itop::resource::extension_git", $prefixed_extensions, $defaults )
  }
}
