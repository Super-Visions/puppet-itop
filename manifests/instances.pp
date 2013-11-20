#
# Doc
#
class itop::instances (
  $version        = undef,
  $base_src_dir   = undef,
  $instance_hash = hiera('itop::instance_hash', {})
)
{
  Class['itop::install'] -> Class['itop::instances']

  validate_hash($instance_hash)
  if( $instance_hash )
  {
    create_resources( 'itop::resource::instance', $instance_hash )
  }
}
