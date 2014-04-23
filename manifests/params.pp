# Class: itop::params
#
# This module manages iTop paramaters
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# This class file is not called directly
class itop::params
{
  #$itop_src_dir  = "${itop_base_src_dir}/${itop_version}"
  $base_src_dir  = '/usr/local/itop'
  $install_type  = 'zip'
  $bin_dir       = "${base_src_dir}/bin"
  $zip_dir       = "${base_src_dir}/zip"
  $ext_dir       = "${src_dir}/extensions"
}
