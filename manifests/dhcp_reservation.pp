# ipam::dhcp_reservation
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   ipam::dhcp_reservation { 'namevar': }
define ipam::dhcp_reservation(
  $mac,
  $ip,
) {
  dhcp::host { $name:
    mac     => $mac,
    ip      => $ip,
    require => Class['ipam::config'],
  }
}
