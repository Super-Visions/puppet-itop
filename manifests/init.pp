# init file for iTop Class
class itop (
  $version        = undef,
  $zip_url        = undef,
  $base_src_dir   = '/usr/local/itop',
  $install_type   = 'zip',
  $extension_hash = {},
  $instance_hash  = {},
)
{

  ### Declaring calculated variables
  $bin_dir        = "${base_src_dir}/bin"
  $zip_dir        = "${base_src_dir}/zip"
  $src_dir        = "${base_src_dir}/${version}"
  $ext_dir        = "${src_dir}/extensions"

  anchor  { 'itop::start': }->
  class   { 'itop::install': }->
  class   { 'itop::instances': }->
  anchor  { 'itop::end': }

}
