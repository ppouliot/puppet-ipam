# == Class: ipam::primary_zone
define ipam::primary_zone ($soa,$soa_email,$nameservers,$allow_transfer,$allow_update,$also_notify){
  dns::zone{ $name:
    soa            => $soa,
    soa_email      => $soa_email,
    nameservers    => $nameservers,
    allow_transfer => $allow_transfer,
    allow_update   => $allow_update,
    also_notify    => $also_notify,
    require        => Class['ipam::config'],
  }
}
