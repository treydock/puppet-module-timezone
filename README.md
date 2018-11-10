# puppet-module-timezone

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with timezone](#setup)
   * [What timezone affects](#what-timezone-affects)
   * [Setup requirements](#setup-requirements)
   * [Beginning with timezone](#beginning-with-timezone)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module description

This module manages the timezone.

## Setup

### What timezone affects

It symlinks `/etc/localtime` to the appropriate timezone under
`/usr/share/zoneinfo/`. On EL6 it manages `/etc/sysconfig/clock`.  On
Debian and Ubuntu it manages `/etc/timezone`.

### Setup requirements

This module has no dependencies outside of stdlib.

### Beginning with timezone

Include the `timezone` class to set your timezone to 'UTC'.

```puppet
include timezone
```

## Usage

### To set the timezone to something other than the default of 'UTC'.

#### Example using a manifest

```puppet
class { 'timezone':
  timezone => 'Europe/Berlin',
}
```

#### Example using Hiera

```yaml
timezone::timezone: 'Europe/Berlin'
```

### If using EL6

You can specify if the hardware clock is set to UTC.

#### Example using a manifest

```puppet
class { 'timezone':
  hwclock_utc => true,
}
```

#### Example using Hiera

```yaml
timezone::hwclock_utc: true
```

## Limitations

This module has been tested to work on the following platforms with the
latest releases of Puppet v5 and v6 with the ruby versions associated with those
platforms. See `.travis.yml` for an exact matrix.

* EL 6
* EL 7
* Debian 8
* Debian 9
* Ubuntu 14.04 LTS
* Ubuntu 16.04 LTS
* Ubuntu 18.04 LTS

## Development

See `CONTRIBUTING.md` for information related to the development of this
module.
