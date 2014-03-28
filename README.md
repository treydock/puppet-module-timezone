# puppet-module-timezone
===

[![Build Status](https://travis-ci.org/time/puppet-module-timezone.png?branch=master)](https://travis-ci.org/time/puppet-module-timezone)

Manage system time zone.

===

# Compatibility
---------------
This module is built for use with Puppet v3 with Ruby versions 1.8.7, 1.9.3, and 2.0.0 on the following OS families.

* EL 6

===

# Parameters


timezone
--------
Time-zone name, e.g. 'GMT' or 'Europe/Berlin', see /usr/share/zoneinfo/ for available values. Default is 'UTC'.

- *Default*: 'UTC'

hwclock_utc
-----------
Boolean to determine if the hardware clock is set to UTC.

- *Default*: true
