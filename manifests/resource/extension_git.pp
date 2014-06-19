
define itop::resource::extension_git (
  $instance_name,
  $user,
  $extension_src_url = $itop::extension_src_url,
  $ext_dir     = undef,
  $revision   = undef,
)
{

  $extension_name = regsubst( $name, "^${instance_name}_", '' )

  notify { "instance_name ${instance_name}:${extension_name}: ": }

  if ! $ext_dir {
    $fix_ext_dir = "${::itop::ext_dir}/${extension_name}/${extension_name}/web/extensions"
  } else {
    $fix_ext_dir = $ext_dir
  }

  vcsrepo { "${fix_ext_dir}/${extension_name}":
    ensure   => latest,
    provider => git,
    source   => "${extension_src_url}/${extension_name}.git",
    revision => $revision,
    user     => $user,
  }

  concat::fragment{ "${extension_name}_config_template":
    target  => "${instance_name}_itop_template_configfile",
    content => template("itop/config_itop/500_mymodulesettings.php.erb"),
    order   => '500',
  }

}
