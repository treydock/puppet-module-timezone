# puppet-module-timezone
===

[![Build Status](https://travis-ci.org/time/puppet-module-timezone.png?branch=master)](https://travis-ci.org/time/puppet-module-timezone)

Manage system time zone.

===

# Compatibility
---------------
This module is built for use with Puppet v3 with Ruby versions 1.8.7, 1.9.3, and 2.0.0 on the following OS families.

* RHEL 6
* Debian

===

# Parameters

timezone
--------
The systems default timezone, e.g. 'UTC' or 'Europe/Berlin'.
See /usr/share/zoneinfo for available values.

- *Default*: 'UTC'

hwclock_utc
-----------
Boolean value Indicating if the system's hardware clock is
reflects UTC (true) or localtime (false). This value is only
used on osfamily RedHat.

- *Default*: true
