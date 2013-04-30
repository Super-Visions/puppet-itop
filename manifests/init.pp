# init file for iTop Class
class itop ( $ensure = undef )
{
  anchor  { 'itop::start': }->
  class   { 'itop::package': ensure => $ensure }->
  class   { 'itop::instance': }->
  anchor  { 'itop::end': }
}
