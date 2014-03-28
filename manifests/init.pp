# == Class: timezone
#
# Module to manage time zone
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
        target => "/usr/share/zoneinfo/${timezone}",
      }
    }
    default: {
      fail("timezone supports osfamily RedHat only. Detected osfamily is <${::osfamily}>.")
    }
  }
}
