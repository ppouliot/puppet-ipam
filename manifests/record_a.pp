# == Class: ipam::record_a
  # Define record_a
define ipam::record_a ($zone,$data,$ptr){
  dns::record::a { $name:
    zone    => $zone,
    data    => $data,
    ptr     => $ptr;
    require => Class['ipam::config'],
  }
}
