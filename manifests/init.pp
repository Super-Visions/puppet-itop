# init file for iTop Class
class itop (
  $version      = $itop::params::itop_version,
  $base_src_dir = $itop::params::itop_base_src_dir,
  $install_type = $itop::params::itop_install_type,
  $url          = $itop::params::itop_url
) inherits itop::params {

  anchor  { 'itop::start': }->
  class   { 'itop::install':
    version      => $version,
    install_type => $install_type,
    url          => $url,
    base_src_dir => $base_src_dir,
  }->
  class   { 'itop::instances': }->
  anchor  { 'itop::end': }

}
