# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab
# == Class: time_zone
#
# Module to manage zone
#
class timezone (
	$timezone = 'GMT',
	$hwclock_utc = 'true'
) {
	validate_re($hwclock_utc, '^(true|false)$', "timezone::hwclock_utc may be either 'true' or 'false' and is set to <${hwclock_utc}>.")
	case $::osfamily {
		'RedHat': {
			file { '/etc/sysconfig/clock':
				content => template('timezone/clock.erb')
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

