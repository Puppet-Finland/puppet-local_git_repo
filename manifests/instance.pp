#
# @summary
#   set up a private Git repository and grant access to it for local
#   users using POSIX Extended ACLs
#
# @param git_url
#   URL of the Git repository to clone
# @param target_dir
#   Path to clone the Git repository to
# @param permissions
#   Extended ACLs to set
#
define local_git_repo::instance (
  String               $git_url,
  Stdlib::Absolutepath $target_dir,
  Array[String]        $permissions,
) {
  include posix_acl::requirements

  # Construct the extended ACLs for the Git repository
  vcsrepo { $target_dir:
    ensure   => 'bare',
    provider => 'git',
    source   => $git_url,
    user     => 'root',
  }

  # Set ACLs for the files that need to be editable for all
  posix_acl { $target_dir:
    action     => set,
    permission => $permissions,
    provider   => posixacl,
    recursive  => true,
    require    => [Vcsrepo[$target_dir], Class['posix_acl::requirements']],
  }
}
