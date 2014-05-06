#
# Class itop::install
#
class itop::install (
  $install_type   = $itop::install_type,
)
{

  anchor  { 'itop::install::start': }->
  class { "itop::install::${install_type}": }->
  class { 'itop::extensions': }->
  anchor  { 'itop::install::end': }

}
