puppet-ulimit
=============

Puppet custom type: ulimit

Example usage:
```
ulimit { 'apache_nofile':
  domain => '@apache',
  type   => 'hard',
  item   => 'nofile',
  value  => '8192',
}
```
This will create a file called /etc/security/limits.d/\<namevar\>.conf containing the limits defined.

Contributions welcome.  Support for managing /etc/security/limits.conf could be added.
