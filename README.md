# local_git_repo

Clone a Git repository and use POSIX extended ACLs to grant access to it.

# Prerequisites

This module depends on three external modules:

* https://forge.puppet.com/modules/puppet/posix_acl
* https://forge.puppet.com/modules/puppetlabs/stdlib
* https://forge.puppet.com/modules/puppetlabs/vcsrepo

# Usage

Example usage:

    $group = 'developers'
    
    local_git_repo::instance { 'myrepo':
      git_url        => 'https://git.example.org/myrepo.git',
      target_dir     => '/var/lib/repos/myrepo',
      permissions    => [ 'default:mask::rwx',
                          'mask::rwx',
                          "default:g:${group}:rwx",
                          "g:${group}:rwx", ],
    }

To share the Git repository with git-daemon using Git protocol (currently
Ubuntu/Debian only):

    class { 'local_git_repo::gitdaemon':
      base_path => '/var/lib/repos',
      directory => '/var/lib/repos/myrepo',
    }

The *directory* parameter is the directory whitelist. Directories not on the
whitelist will not be exported by git-daemon. Based on git-daemon documentation
it should accept a string with multiple directories separated by a space.
