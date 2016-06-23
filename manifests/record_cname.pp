# == Class: ipam::record_cname
#
# $zone
# $data
#
  #  Define record_cname
  define record_cname($zone,$data){
    dns::record::cname { $name:
      zone    => $zone,
      data    => $data,
      require => Class['ipam::config'],
    }
  }
}
