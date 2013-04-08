class itop
{
  anchor { 'itop::start': }->
  class { 'itop::package': }->
  class { 'itop::instance': }->
  anchor { 'itop::end': }
}
