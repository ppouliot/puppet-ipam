# ipam::record_a
#
# A description of what this defined type does
#
# @summary Ddefined type for a Bind A Record
#
# @example
#   ipam::record_a { 'namevar': }
define ipam::record_a (
  String $zone,
  String $data,
  Optional[Boolean] $ptr = undef,
) {
  dns::record::a { $name:
    zone    => $zone,
    data    => $data,
    ptr     => $ptr,
    require => Class['ipam::config'],
  }
}
