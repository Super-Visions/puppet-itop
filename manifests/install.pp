#
# Class itop::install
#
class itop::install (
  $base_install_type   = $itop::base_install_type,
)
{

  anchor  { 'itop::install::start': }->
  class { "itop::install::${base_install_type}": }->
  class { 'itop::extensions': }->
  anchor  { 'itop::install::end': }

}
