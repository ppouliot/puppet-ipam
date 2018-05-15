# ipam::dhcp_reservation
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   ipam::dhcp_reservation { 'namevar': }
define ipam::dhcp_reservation(
  String $mac,
  String $ip,
) {
  if $mac.is_mac_address == 'true' {
    # notice("${mac} is a valid mac address.") 
    warning("${mac} is a valid mac address.") 
  }
  if $mac.is_mac_address == 'false' {
    warning("${mac} is not a valid mac address!")
  }

  dhcp::host { $name:
    mac     => $mac,
    ip      => $ip,
    require => Class['ipam::config'],
  }
}
