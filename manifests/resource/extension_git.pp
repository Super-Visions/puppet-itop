#  iTop Custom Extensions installation.
#
#  Valid for own created extenstions and TeemIP.
#
#  Requirements:   - Source file must be a zip file
#                  - Internal structure for the zip is:
#                            web/extensions/<extension directory name>
#
define itop::resource::extension_git (
  $extension_src_url = $itop::extension_src_url,
  $target     = $itop::ext_dir,
  $zip_target = $itop::zip_dir,
)
{
  # archive { $name:
  #   ensure     => present,
  #   checksum   => true,
  #   extension  => 'zip',
  #   url        => "${extension_src_url}/${name}.zip",
  #   target     => $target,
  #   src_target => $zip_target,
  # }
  vcsrepo { "${target}/${name}":
    ensure   => present,
    provider => git,
    source   => "${extension_src_url}/${name}.git",
    #revision => '0c466b8a5a45f6cd7de82c08df2fb4ce1e920a31',
    #user => 'someUser'
  }
}
