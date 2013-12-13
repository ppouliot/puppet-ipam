class ipam {


  # Responsible for Primary Name Services, DHCP, and LDAP
  # Bind Configuration

  $master             =  hiera('master',{})
  $primary            = hiera('primary',{})
  $ddnskey            = hiera('ddnskey',{})
  $slave              = hiera('slave',{})
  $dhcpdata           = hiera('dhcpdata',{})
  $static_leases      = hiera('static_leases',{})
  $dns_records_a      = hiera('dns_records_a',{})
  $dns_records_cname  = hiera('dns_records_cname',{})
  
  # Installs DNS Server
  include dns::server

  package {'apparmor':
    ensure => absent,
  }

  # generate key for use with dhcp 
  user {"dhcpd":
    groups => ["dhcpd","bind"],
  }

  case $master {
    'true':{
       dns::key{ $ddnskey: }
    }
    default:{
      notify {"${hostname} is not a master":}
    }
  }

# Import Zone Types  

  import 'params'

#  Slave and Primary Zones
  create_resources(primary_zone,$primary)
  create_resources(slave_zone,$slave)

# Import Name Records
  create_resources(record_a,$dns_records_a)
  create_resources(record_cname,$dns_records_cname)

  
  # isc-dhcp-server

  create_resources(dhcp_ip_pools,$dhcpdata)
  create_resources(dhcp_reservation,$static_leases)

  class { 'dhcp':
    dnsdomain    => hiera("dhcp::dnsdomain"),
    nameservers  => hiera("dhcp::nameservers"),
    ntpservers   => hiera("dhcp::ntpservers"),
    interfaces   => hiera("dhcp::interfaces"),
    dnsupdatekey => "/etc/bind/bind.keys.d/${ddnskey}.key", 
#    require      => Dns::Key[$ddnskey],
#  }
  
  class {'dhcp::failover':
    role         => hiera("dhcp::failover::role"),
    peer_address => hiera("dhcp::failover::peer_address"),
  }

  
  Dhcp::Pool{ failover => "dhcp-failover" }
  
}
