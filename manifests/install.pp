#
# Class itop::install
#
class itop::install (
  $version        = undef,
  $base_src_dir   = undef,
  $install_type   = 'zip',
  $url            = undef,
  $extension_hash = undef,
)
{
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
