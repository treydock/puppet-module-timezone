# @summary This module manages the system's default timezone setting.
#
# @example Declaring the class
#   include timezone
#
# @param timezone
#   The systems default timezone, e.g. 'UTC' or 'Europe/Berlin'. See
#   `/usr/share/zoneinfo` for available values.
#
# @param hwclock_utc
#   Optional boolean value indicating if the system's hardware clock is UTC
#   (true) or localtime (false). This value is only used on EL 6. If set to
#   `undef` the `UTC` setting will not be present in `/etc/sysconfig/clock`.
#
class timezone (
  String            $timezone    = 'UTC',
  Optional[Boolean] $hwclock_utc = undef,
) {

  $tzdata = "/usr/share/zoneinfo/${timezone}"

  file { '/etc/localtime':
    ensure => link,
    target => $tzdata,
  }

  case $facts['os']['family'] {
    'RedHat': {


      if $facts['os']['release']['major'] == '6' {
        file { '/etc/sysconfig/clock':
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template('timezone/clock.erb'),
        }
      }
    }
    'Debian': {

      file { '/etc/timezone':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => "${timezone}\n",
      }
    }
    default: {
      fail("Detected os.family <${facts['os']['family']}> is not supported.")
    }
  }
}
