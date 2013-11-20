# init file for iTop Class
class itop (
  $version      = undef,
  $base_src_dir = undef,
  $install_type = undef,
  $url          = undef
)
{
  anchor  { 'itop::start': }->
  class   { 'itop::install':
    version      => $version,
    install_type => $install_type,
    url          => $url,
    base_src_dir => $base_src_dir,
  }->
  class   { 'itop::instances':
    version      => $version,
    base_src_dir => $base_src_dir,
  }->
  anchor  { 'itop::end': }
}
