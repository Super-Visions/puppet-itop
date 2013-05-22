# init file for iTop Class
class itop (
  $ensure = undef,
  $install_type = undef,
  $url = undef,
)
{
  anchor  { 'itop::start': }->
  class   { 'itop::install': 
    ensure       => $ensure,
    install_type => $install_type,
    $url         => $url,
  }->
  class   { 'itop::instance': }->
  anchor  { 'itop::end': }
}
