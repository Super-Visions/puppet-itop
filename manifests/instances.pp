#
# Doc
#
class itop::instances (
  $instance_hash = hiera('itop::instance_hash', {}) 
)
{
  Class['itop::install'] -> Class['itop::instances']

  validate_hash($instance_hash)
  if( $instance_hash )
  {
    create_resources( 'itop::instance', $instance_hash )
  }
}
