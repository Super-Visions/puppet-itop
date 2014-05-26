#
# Class itop::install
#
class itop::install::zip (
  $itop_version        = $itop::itop_version,
  #$zip_url        = $itop::zip_url,
  $base_src_url   = $itop::base_src_url,
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

  archive { "iTop-${itop_version}":
    ensure     => present,
    checksum   => true,
    extension  => 'zip',
    url        => "${base_src_url}/iTop-${itop_version}.zip",
    target     => $base_src_dir,
    src_target => $zip_target,
    root_dir   => $itop_version,
    require    => File[$zip_target],
  }

  archive { 'toolkit-2.0':
    ensure     => present,
    checksum   => true,
    extension  => 'zip',
    url        => "${base_src_url}/toolkit-2.0.zip",
    target     => $src_dir,
    src_target => $zip_target,
    root_dir   => 'toolkit',
    require    => Archive["iTop-${itop_version}"],
  }

  file { $bin_dir:
    ensure    => directory,
    require   => Archive["iTop-${itop_version}"],
  }

  file { "${bin_dir}/install_itop_site":
    ensure  => present,
    content => template('itop/install_itop_site'),
    mode    => '0750',
    require => File[$bin_dir],
  }
}
