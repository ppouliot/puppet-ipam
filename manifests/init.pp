# ipam
#
# Configures Bind/ISC-DHCP-Server IPAM Infrastructure
#
# @summary Responsible for Primary Name Services, DHCP and (maybe LDAP someday)
#
# @example
#   include ipam
class ipam (
  $master             = hiera('master',true),
  $server_interface   = hiera('ipam::server_interface',{}),
  $primary            = hiera('primary',{}),
  $ddnskey            = hiera('ddnskey','default'),
  $slave              = hiera('slave',{}),
  $dhcpdata           = hiera('dhcpdata',{}),
  $static_leases      = hiera('static_leases',{}),
  $dns_records_a      = hiera('dns_records_a',{}),
  $dns_records_cname  = hiera('dns_records_cname',{}),
  $dhcp_use_failover  = true,
  $primary_defaults   = {},
  $slave_defaults     = {},
) inherits ipam::params {
# Installs DNS Server and DHCP Server

  class{'ipam::install':}
->  class{'ipam::config': }

#  Slave and Primary Zones
  create_resources(ipam::primary_zone,$primary,$primary_defaults)
  create_resources(ipam::slave_zone,$slave,$slave_defaults)

  # A and CNAME Records
  create_resources(ipam::record_a,$dns_records_a)
  create_resources(ipam::record_cname,$dns_records_cname)

  # isc-dhcp-server dhcp datapools and leaces
  create_resources(ipam::dhcp_ip_pools,$dhcpdata)
  create_resources(ipam::dhcp_reservation,$static_leases)
}
