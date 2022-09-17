# timezone

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

This module manages the timezone. Documented with Puppet Strings at
[http://ghoneycutt.github.io/puppet-module-timezone/](http://ghoneycutt.github.io/puppet-module-timezone/).

## Setup

### What timezone affects

It symlinks `/etc/localtime` to the appropriate timezone under
`/usr/share/zoneinfo/`. On Debian and Ubuntu it manages `/etc/timezone`.

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

## Limitations

This module officially supports the platforms listed in the
`metadata.json`. It does not fail on unsupported platforms and has been
known to work on many Linux platforms since its creation in 2014.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

See [LICENSE](LICENSE) file.
