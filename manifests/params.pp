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
class itop::params (
  $itop_version       = undef,
  $itop_base_src_dir  = '/usr/local/itop',
  $itop_install_type  = 'zip',
  $itop_url           = undef,
)
{
  $itop_src_dir     = "${itop_base_src_dir}/${itop_version}"
  $itop_bin_dir     = "${itop_base_src_dir}/bin"
  $itop_zip_dir     = "${itop_base_src_dir}/zip"
  $itop_ext_dir     = "${itop_src_dir}/extensions"
}
