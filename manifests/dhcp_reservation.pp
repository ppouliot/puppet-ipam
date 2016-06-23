# == Class: ipam::dhcp_reservation
  # Define DHCP Host Reservation
  define ipam::dhcp_reservation($mac,$ip){
    dhcp::host { $name:
      mac     => $mac,
      ip      => $ip;
      require => Class['ipam::config'],
    }
  }
}
