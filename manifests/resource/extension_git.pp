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
  $ext_dir     = "$itop::ext_dir/${name}/${name}/web/extensions",
  $revision   = undef,
)
{

  vcsrepo { "${ext_dir}/${name}":
    ensure   => latest,
    provider => git,
    source   => "${extension_src_url}/${name}.git",
    revision => $revision,
    #user    => 'someUser'
  }

}
