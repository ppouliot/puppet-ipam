# ipam::dhcp_ip_pools
#
# Defines IPAM DHCP IP Pools
#
# @summary Define IP Data Format
#
# @example
#   ipam::dhcp_ip_pools { 'namevar': }
define ipam::dhcp_ip_pools(
  String $failover,
  String $network,
  String $mask,
  String $gateway,
  String $range,
  $options,
  $parameters,
) {
  dhcp::pool{ $name :
    failover   => $failover,
    network    => $network,
    mask       => $mask,
    gateway    => $gateway,
    range      => $range,
    options    => $options,
    parameters => $parameters,
    require    => Class['ipam::config'],
  }
}
