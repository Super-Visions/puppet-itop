define itop::resource::extensions_git (
  $extensions,
  $docroot,
  $default_revision,
  $user,
)
{

  validate_hash($extensions)
  if( $extensions )
  {
    $prefixed_extensions = prefix_hash_keys( $extensions, "${name}_" )

    validate_hash($prefixed_extensions)

    $defaults = {
      instance_name => $name,
      user => $user,
      revision => $default_revision,
      ext_dir  => "$docroot/extensions",
    }

    create_resources( "itop::resource::extension_git", $prefixed_extensions, $defaults )
  }
}
