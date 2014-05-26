# init file for iTop Class
class itop (
  $installroot,
  $itop_version    = undef,
  $zip_url        = undef,
  $base_src_url        = undef,
  $extension_src_url        = undef,
  $base_src_dir   = '/usr/local/itop',
  $base_install_type   = 'zip',
  $extension_install_type   = 'zip',
  $extension_hash = {},
  $instance_hash  = {},
)
{

  ### Declaring calculated variables
  $bin_dir        = "${base_src_dir}/bin"
  $zip_dir        = "${base_src_dir}/zip"
  $git_dir        = "${base_src_dir}/git"
  $src_dir        = "${base_src_dir}/${itop_version}"
  $ext_dir        = "${src_dir}/extensions"

  anchor  { 'itop::start': }->
  class   { 'itop::install': }->
  class   { 'itop::instances': }->
  anchor  { 'itop::end': }

}
