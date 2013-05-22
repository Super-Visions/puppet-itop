#
# Class itop::install
#
class itop::install (
  $ensure       => undef,
  $install_type => 'package',
  $urli         => undef,
)
{
  class { "itop::install::${install_type}":
    ensure => $ensure.
    url    => $url,
  }
}
