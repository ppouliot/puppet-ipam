# include ipam
dns::key{"$::fqdn":}
class { 'ipam': }
