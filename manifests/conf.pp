# @summary The `dnsmasq::conf` defined type is to config dnsmasq, it is the details of configuration file for dnsmasq.
#
# Manage dnsmasq server configuration details. If the `source` attribute is `undef`(default) or unmanaged, the
# configuration file's content is determined by the other attributes. Otherwise, the configuration file's content
# copied from the `soure` url.
#
# The dnsmasq::conf defined type can have multiple instances with different titles(the name attribute defaut value),
# which corresponding to their own configuration files. Options which accept just a single value, the entry in the
# configuration file with the `priority` value, bigger value takes precedence. For options which accept a list of
# values, entries are collected as they occur in files sorted by `priority` values.
#
# @example
#   dnsmasq::conf { 'dnsmasq': }
#
# @param ensure
#   Whether the file should exist. Possible values are present, absent, and file.
#
#   Default value: 'present'
#
# @param priority
#   The priority of file in /etc/dnsmasq.d/ directory, which is part of the configuration file name.
#
#   Default value: 10
#
# @param source
#   A source file, which will be copied into the configuration file. If this attribute is not `undef`, the
#   other detail attributes that based on template to build the configuration file's content are ignored. 
#   This attribute is for you that have some validate configuration files.
#   Allowed values are:
#     - `puppet`: URIs, which point to files in modules or Puppet file server mount points.
#     - Fully qualified paths to locally available files (including files on NFS shares or Windows mapped drives).
#     - `file`: URIs, which behave the same as local file paths.
#     - `http(s)`: URIs, which point to files served by common web servers.
#
#   Default value: undef
#
# @param port
#   Listen on this specific port instead of the standard DNS port (53). Setting this to zero completely disables
#   DNS function, leaving only DHCP and/or TFTP.
#
#   Default value: undef
#
# @param domain_needed
#   Never forward plain names (without a dot or domain part)
#
#   Default value: true
#
# @param bogus_priv
#   Never forward addresses in the non-routed address spaces.
#
#   Default value: true
#
# @param dnssec
#   Enable DNSSEC validation and caching.
#
#   Default value: false
#
# @param dnssec_check_unsigned
#   Replies which are not DNSSEC signed may be legitimate, because the domain is unsigned, or may be forgeries. 
#   Setting this option tells dnsmasq to check that an unsigned reply is OK, by finding a secure proof that a DS
#   record somewhere between the root and the domain does not exist.
#   The cost of setting this is that even queries in unsigned domains will need one or more extra DNS queries to verify.
#
#   Default value: false
#
# @param filterwin2k
#   Setup this attr true to filter useless windows-originated DNS requests which can trigger dial-on-demand links 
#   needlessly. Note that (amongst other things) this blocks all SRV requests, so don't use it if you use eg Kerberos,
#   SIP, XMMP or Google-talk. This option only affects forwarding, SRV records originating for dnsmasq (via srv-host= 
#   lines) are not suppressed by it.
#
#   Default value: true
#
# @param resolv_file
#   Change this line if you want dns to get its upstream servers from somewhere other that /etc/resolv.conf. 
#   for example, set this attr's value: /etc/resolv.dnsmasq
#
#   Default value: '/etc/resolv.conf'
#
#
#
#
#
#
#
#
#
define dnsmasq::conf (
  Enum['present','file','absent'] $ensure  = 'present',
  Integer   $priority              = 10,
  String[1] $source                = undef,

  # conf params
  String[1] $port                  = undef,
  Boolean   $domain_needed         = true,
  Boolean   $bogus_priv            = true,
  Boolean   $dnssec                = false,
  Boolean   $dnssec_check_unsigned = false,
  Boolean   $filterwin2k           = true,
  String[1] $resolv_file           = '/etc/resolv.conf',
) {

  include ::dnsmasq

  File {
    owner => 'root',
    group => 'root',
  }

  if $source {
    file { "${dnsmasq::params::config_dir}${priority}-${name}.conf":
      ensure => $ensure,
      source => $source,
      notify => Class['dnsmasq::service'],
    }
  }
  else {
    file { "${dnsmasq::params::config_dir}${priority}-${name}.conf":
      ensure  => $ensure,
      content => template('dnsmasq/dnsmasq.conf.erb'),
      notify  => Class['dnsmasq::service'],
    }
  }
}
