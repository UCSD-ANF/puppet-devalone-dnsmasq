# @summary Install the main configuration file
#
# Installs a configuration file for dnsmasq
#
# @api private
#
# @example
#   include dnsmasq::config
#
# @param root_group
#   Override the file group ownership
class dnsmasq::config (
  Optional[String] $root_group = undef,
) {
  include dnsmasq

  $root_group_real = $root_group ? {
    undef => $dnsmasq::root_group,
    default => $root_group,
  }

  File {
    owner => 'root',
    group => $root_group_real,
  }

  file { $dnsmasq::config_file:
    mode   => '0644',
    source => 'puppet:///modules/dnsmasq/dnsmasq.conf',
  }
}
