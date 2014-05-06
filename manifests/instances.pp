#
# Doc
#
class itop::instances (
  $instance_hash = $itop::instance_hash,
)
{
  Class['itop::install'] -> Class['itop::instances']

  validate_hash($instance_hash)
  if( $instance_hash )
  {
    create_resources( 'itop::resource::instance', $instance_hash )
  }
}
