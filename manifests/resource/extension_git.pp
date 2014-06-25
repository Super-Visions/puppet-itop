
define itop::resource::extension_git (
  $instance_name,
  $user,
  $extension_src_url = $itop::extension_src_url,
  $ext_dir           = undef,
  $revision          = undef,
  $install           = true,
)
{

  $extension_name = regsubst( $name, "^${instance_name}_", '' )

  #notify { "instance_name ${instance_name}:${extension_name}: ": }

  $config = $itop::instance_hash[$instance_name]['extension_config'][$extension_name]

  #notify { "Config ${instance_name}:${extension_name}: ${config}": }

  if $install {
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
  }

  if $config {
    #notify { "HAS !! Config ${instance_name}:${extension_name}: ${config}": }

    concat::fragment{ "${extension_name}_config_template":
      target  => "${instance_name}_itop_template_configfile",
      content => template("itop/config_itop/500_mod_${extension_name}.php.erb"),
      order   => "${config['order']}",
    }
  }

}
