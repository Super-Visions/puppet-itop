#
# Class itop::install
#
class itop::install (
  $ensure         = undef,
  $install_type   = 'zip',
  $url            = undef,
  $extension_hash = undef,
)
{
  anchor  { 'itop::install::start': }->
  class { "itop::install::${install_type}":
    ensure => $ensure,
    url    => $url,
  }->
  class { 'itop::extensions':
    extension_hash => $extension_hash
  }->
  anchor  { 'itop::install::end': }
}
