# == Class: ipam::slave_zone
  # Define slave_zone
define ipam::slave_zone ($slave_masters,$zone_type){
  dns::zone { $name:
    slave_masters => $slave_masters,
    zone_type     => $zone_type,
    require       => Class['ipam::config'],
  }
}
