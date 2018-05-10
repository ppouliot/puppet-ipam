# ipam::slave_zone
#
# Defines a slave zone in bind
#
# @summary Defined type for a slave zone in bind.
#
# @example
#   ipam::slave_zone { 'namevar': }
define ipam::slave_zone(
  String $slave_masters,
  String $zone_type,
){
  dns::zone { $name:
    slave_masters => $slave_masters,
    zone_type     => $zone_type,
    require       => Class['ipam::config'],
  }
}
