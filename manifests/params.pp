define primary_zone ($soa,$soa_email,$nameservers){
  include dns::server
  dns::zone{ $name:
    soa         => $soa,
    soa_email   => $soa_email,
    nameservers => $nameservers,
  }
}

define slave_zone ($slave_masters,$zone_type){
  dns::zone { $name:
    slave_masters => $slave_masters,
    zone_type     => $zone_type,
  }
}

define record_a ($zone,$data,$ptr){
  dns::record::a { $name:
      zone => $zone,
      data => $data,
      ptr  => $ptr;
  }
}
define record_cname($zone,$data){
  dns::record::cname { $name:
    zone => $zone,
    data => $data;
  }
}

# Define IP Data Format
define dhcp_ip_pools ($failover,$network,$mask,$gateway,$range,$options,$parameters){
  dhcp::pool{ $name :
       failover   => $failover,
       network    => $network,
       mask       => $mask,
       gateway    => $gateway,
       range      => $range,
       options    => $options,
       parameters => $parameters;
    }
}

# Define DHCP Host
define dhcp_reservation($mac,$ip){
  dhcp::host { $name:
    mac => $mac,
    ip => $ip;
  }
}

