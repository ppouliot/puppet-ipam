# == Class: ipam::dhcp_ip_pools
  # Define IP Data Format
  define ipam::dhcp_ip_pools (
    $failover,
    $network,
    $mask,
    $gateway,
    $range,
    $options,
    $parameters){

  dhcp::pool{ $name :
    failover   => $failover,
    network    => $network,
    mask       => $mask,
    gateway    => $gateway,
    range      => $range,
    options    => $options,
    parameters => $parameters;
    require    => Class['ipam::config'],
  }
}
