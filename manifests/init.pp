# @summary This module manages the system's default timezone setting.
#
# @example Declaring the class
#   include timezone
#
# @param timezone
#   The systems default timezone, e.g. 'UTC' or 'Europe/Berlin'. See
#   `/usr/share/zoneinfo` for available values.
#
class timezone (
  String[1] $timezone = 'UTC',
) {

  $tzdata = "/usr/share/zoneinfo/${timezone}"

  file { '/etc/localtime':
    ensure => link,
    target => $tzdata,
  }

  if $facts['os']['family'] == 'Debian' {
    file { '/etc/timezone':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "${timezone}\n",
    }
  }
}
