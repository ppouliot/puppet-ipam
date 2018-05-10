# ipam::record_cname
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   ipam::record_cname { 'namevar': }
define ipam::record_cname(
  String $zone,
  String $data,
) {
  dns::record::cname { $name:
    zone    => $zone,
    data    => $data,
    require => Class['ipam::config'],
  }
}
