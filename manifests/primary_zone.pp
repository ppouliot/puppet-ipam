# == Class: ipam::primary_zone
define ipam::primary_zone ($soa,$soa_email,$nameservers,$allow_transfer){
  dns::zone{ $name:
    soa            => $soa,
    soa_email      => $soa_email,
    nameservers    => $nameservers,
    allow_transfer => $allow_transfer,
    require        => Class['ipam::config'],
  }
}
