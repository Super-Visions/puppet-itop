#
# Class itop::install
#
class itop::install (
  $version        = $itop::params::itop_version,
  $base_src_dir   = $itop::params::itop_base_src_dir,
  $install_type   = $itop::params::itop_install_type,
  $url            = $itop::params::itop_url,
  $extension_hash = undef,
) inherits itop::params {

  anchor  { 'itop::install::start': }->
  class { "itop::install::${install_type}":
    version      => $version,
    url          => $url,
    base_src_dir => $base_src_dir,
  }->
  class { 'itop::extensions':
    extension_hash => $extension_hash
  }->
  anchor  { 'itop::install::end': }
}
