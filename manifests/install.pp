# @summary Install dnsmasq package
#
# This class use the dnsmasq params to install or uninstall the dnsmasq package, and manage the config dir.
#
# @api private
#
# @example
#   include dnsmasq::install
class dnsmasq::install {
  include dnsmasq

  if $dnsmasq::package_manage {
    package { $dnsmasq::package_name:
      ensure => $dnsmasq::package_ensure,
    }
  }

  if $dnsmasq::purge_config_dir {
    file { $dnsmasq::config_dir:
      ensure  => 'directory',
      recurse => true,
      purge   => true,
      force   => true,
    }
  } else {
    file { $dnsmasq::config_dir:
      ensure => 'directory',
    }
  }
}
