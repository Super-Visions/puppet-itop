# init file for iTop Class
class itop (
  $version        = undef,
  $zip_url        = undef, 
  $base_src_dir   = $itop::params::base_src_dir,
  $install_type   = $itop::params::install_type,
  $bin_dir        = $itop::params::bin_dir,
  $zip_dir        = $itop::params::zip_dir,
  $ext_dir        = $itop::params::ext_dir,
  $extension_hash = {},
  $instance_hash  = {},
) inherits itop::params {

  anchor  { 'itop::start': }->
  class   { 'itop::install': }->
  class   { 'itop::instances': }->
  anchor  { 'itop::end': }

}
