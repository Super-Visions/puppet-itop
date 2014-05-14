#
# Class itop::install
#
class itop::install::zip (
  $version        = $itop::version,
  $zip_url        = $itop::zip_url,
  $base_src_dir   = $itop::base_src_dir,
  $src_dir        = $itop::src_dir,
  $bin_dir        = $itop::bin_dir,
  $zip_target     = $itop::zip_dir,
)
{

  file { $base_src_dir:
    ensure => directory,
  }

  file { $zip_target:
    ensure  => directory,
    require => File[$base_src_dir],
  }

  archive { "iTop-${version}":
    ensure     => present,
    checksum   => true,
    extension  => 'zip',
    url        => "${zip_url}/iTop-${version}.zip",
    target     => $base_src_dir,
    src_target => $zip_target,
    root_dir   => $version,
    require    => File[$zip_target],
  }

  archive { 'toolkit-2.0':
    ensure     => present,
    checksum   => true,
    extension  => 'zip',
    url        => "${zip_url}/toolkit-2.0.zip",
    target     => $src_dir,
    src_target => $zip_target,
    root_dir   => 'toolkit',
    require    => Archive["iTop-${version}"],
  }

  file { $bin_dir:
    ensure    => directory,
    require   => Archive["iTop-${version}"],
  }

  file { "${bin_dir}/install_itop_site":
    ensure  => present,
    content => template('itop/install_itop_site'),
    mode    => '0750',
    require => File[$bin_dir],
  }
}
