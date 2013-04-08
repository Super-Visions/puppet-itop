class itop
{
  anchor { 'itop::start': }->
  class { 'itop::install': }->
  class { 'itop::instance': }->
  anchor { 'itop::end': }
}
