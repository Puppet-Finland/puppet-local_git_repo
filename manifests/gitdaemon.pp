#
# @summary set up git-daemon
#
# @param base_path
#   Base path for git-daemon
# @param directory
#   Directory to whitelist. Space-separated list of directories should also
#   work.
#
class local_git_repo::gitdaemon (
  Stdlib::Absolutepath $base_path,
  String               $directory
) {
  if $facts['os']['family'] != 'Debian' {
    fail('ERROR: local_git_repo::gitdaemon currently only supports Debian/Ubuntu')
  }

  $package_name = 'git-daemon-sysvinit'
  $service_name = 'git-daemon'

  package { $package_name:
    ensure => 'present',
  }

  $ini_settings = { 'GIT_DAEMON_ENABLE'    => true,
    'GIT_DAEMON_BASE_PATH' => $base_path,
    'GIT_DAEMON_DIRECTORY' => $directory,
  'GIT_DAEMON_OPTIONS'   => '"--export-all"', }

  $ini_settings.each |$item| {
    ini_setting { $item[0]:
      ensure  => 'present',
      path    => '/etc/default/git-daemon',
      setting => $item[0],
      value   => $item[1],
      require => Package[$package_name],
      before  => Service[$service_name],
      notify  => Service[$service_name],
    }
  }

  service { $service_name:
    ensure => 'running',
    enable => true,
  }
}
