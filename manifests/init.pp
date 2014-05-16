# == Class: timezone
#
# Manage system's default timezone setting.
#
# === Parameters
#
# [*timezone*]
#   The systems default timezone, e.g. 'UTC' or 'Europe/Berlin'.
#   See /usr/share/zoneinfo for available values.
#   Default: 'UTC'.
#
# [*hwclock_utc*]
#   Boolean value Indicating if the system's hardware clock is
#   reflects UTC (true) or localtime (false). This value is only
#   used on osfamily RedHat.
#   Default: true.
#
# === Examples
#
# class { 'timezone': timezone => 'Europe/Berlin' }
#
# === Authors
#
# Niklas Grossmann <ngrossmann@gmx.net>
#
# === Copyright
#
# Copyright 2014 Niklas Grossmann, unless otherwise noted.
#
class timezone (
  $timezone    = 'UTC',
  $hwclock_utc = true,
) {

  if type($hwclock_utc) == 'string' {
    $hwclock_utc_real = str2bool($hwclock_utc)
  } else {
    $hwclock_utc_real = $hwclock_utc
  }
  validate_bool($hwclock_utc)

  $tzdata = "/usr/share/zoneinfo/${timezone}"
  validate_absolute_path($tzdata)

  case $::osfamily {
    'RedHat': {

      file { '/etc/sysconfig/clock':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('timezone/clock.erb'),
      }

      file { '/etc/localtime':
        ensure => link,
        target => $tzdata,
      }
    }
    'Debian': {
      file { '/etc/timezone':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => "$timezone\n",
      }
      file { '/etc/localtime':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => file($tzdata),
      }
    }
    default: {
      fail("timezone supports osfamily RedHat and Debian. Detected osfamily is <${::osfamily}>.")
    }
  }
}

