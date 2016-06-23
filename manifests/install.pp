# == Class: ipam::install
class ipam::install

  # Install DNS Server
  include dns::server

  # Remove Apparmor
  package {'apparmor':
    ensure => absent,
  }

  if $master == !false {
    @dns::key{ $ddnskey: }
  }

  class { 'dhcp':
    dnsdomain   => hiera('dhcp::dnsdomain'),
    nameservers => hiera('dhcp::nameservers'),
    ntpservers  => hiera('dhcp::ntpservers'),
    interfaces  => hiera('dhcp::interfaces'),
#   dnsupdatekey => "/etc/bind/bind.keys.d/${ddnskey}.key",
#   require      => Dns::Key[$ddnskey],
  }
  if ($ipam::dhcp_use_failover) {
    class {'dhcp::failover':
      role         => hiera('dhcp::failover::role'),
      peer_address => hiera('dhcp::failover::peer_address'),
    }
    Dhcp::Pool{ failover => 'dhcp-failover' }
  }

}
