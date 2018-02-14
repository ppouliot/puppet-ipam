# Node Definition for DNS/DHCP infra

node /^(norman|mother|ipam[0-9\.]+)/ {
# Legacy stuff commented out, rest handled by site.pp and hiera.
#  include basenode::params
#  package {$nfs_packages:
#    ensure => latest,
#  }
#  create_resources(basenode::nfs_mounts,$nfs_mounts)
# Sensu is currently disabled
#  class {'sensu':}
#  class {'sensu_client_plugins': require => Class['sensu'],}
  case $::osfamily {
    'Debian':{
      $prereq_packages = [
      'dnsutils',
      'perl-doc',
      'libnetaddr-ip-perl',
#      'bind-pkcs11-utils',
      'libnet-snmp-perl',
      ]
      $tar = '/bin/tar'
    }
    'RedHat':{
      $prereq_packages = [
      'bind-utils',
      'perl-DB_File',
      'perl-NetAddr-IP',
      'bind-pkcs11-utils',
      'net-snmp',
      ]
      $tar = '/usr/bin/tar'
    }
    default:{
      warning("${fqdn} is using an unsupported platform")
    }
  }

  package{ $prereq_packages:
    ensure => latest,
  }
  class{'staging':
    path => '/opt/staging',
    owner => 'root',
    group => 'root'
  }
  # dhcpd-pool 
  # script for generating dhcpd monitoring information 
  # More information on usage
  # http://folk.uio.no/trondham/software/dhcpd-pool.html

  staging::deploy{'dhcpd-pool-0.2.tar.gz':
    source  => 'http://folk.uio.no/trondham/software/dhcpd-pool-0.2.tar.gz',
    target  => '/opt',
    require => Package[$prereq_packages],
  }
  staging::file{'dhcpd-pools-2.29.tar.xz':
    source  => 'https://downloads.sourceforge.net/project/dhcpd-pools/dhcpd-pools-2.29.tar.xz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fdhcpd-pools%2Ffiles%2F&ts=1510685804&use_mirror=gigenet',
  }
  staging::deploy{'dhcpstatus_0.60.tar.gz':
    source => 'http://downloads.sourceforge.net/project/dhcpstatus/dhcpstatus/v0.60/dhcpstatus_0.60.tar.gz?r=http%3A%2F%2Fdhcpstatus.sourceforge.net%2F&ts=1480997571&use_mirror=pilotfiber',
    target  => '/opt',
    require => Package[$prereq_packages],
  }
  file{'/usr/local/dhcpstatus':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  } ->
  exec{'untar-dhcpstatus_0.60-lib':
    command => "${tar} -xvf /opt/dhcpstatus_0.60/libraries.tar",
    cwd     =>'/usr/local/dhcpstatus',
    creates => [
      '/usr/local/dhcpstatus/dhcpstatus',
      '/usr/local/dhcpstatus/dhcpstatus.ini',
      '/usr/local/dhcpstatus/dhcpstatus/common.pm',
      '/usr/local/dhcpstatus/dhcpstatus/dhcpstatus_cmd.pm',
      '/usr/local/dhcpstatus/dhcpstatus/dhcpstatus.pm',
      '/usr/local/dhcpstatus/dhcpstatus/dhcpstatus_subnet_cmd.pm',
      '/usr/local/dhcpstatus/dhcpstatus/display_html.pm',
      '/usr/local/dhcpstatus/dhcpstatus/Display.pm',
      '/usr/local/dhcpstatus/dhcpstatus/iptools.pm',
      '/usr/local/dhcpstatus/dhcpstatus/Line_print.pm',
      '/usr/local/dhcpstatus/dhcpstatus/Subnet.pm',
      '/usr/local/dhcpstatus/dhcpstatus/dhcpstatus_cgi.pm',
      '/usr/local/dhcpstatus/dhcpstatus/Dhcpstatus_env.pm',
      '/usr/local/dhcpstatus/dhcpstatus/dhcpstatus_subnet_cgi.pm',
      '/usr/local/dhcpstatus/dhcpstatus/dhcpstatus_subnet.pm',
      '/usr/local/dhcpstatus/dhcpstatus/display_line.pm',
      '/usr/local/dhcpstatus/dhcpstatus/Formatted_text.pm',
      '/usr/local/dhcpstatus/dhcpstatus/Lease.pm',
      '/usr/local/dhcpstatus/dhcpstatus/Pool.pm',
   ],
   onlyif    => '/usr/bin/test ! -f /usr/local/dhcpstatus/dhcpstatus/common.pm',
   logoutput => true,
  } ->
  file{'/usr/local/dhcpstatus/dhcpstatus.ini':
    ensure => file,
    content => '# !!! THIS FILE IS MANAGED BY PUPPET !!!
title=DHCP Subnet Information
conf_file=/etc/dhcp/dhcpd.conf
leases_file=/var/lib/dhcpd/dhcpd.leases
show_whole_subnet=0
screen_width=80
',
  }
  vcsrepo{'/opt/dhcpd-snmp':
    ensure   => 'latest',
    provider => 'git',
    source   => 'https://github.com/ohitz/dhcpd-snmp',
    revision => 'master',
  }
#  vcsrepo{'/opt/dhcpd-pools':
#    ensure   => 'latest',
#    ensure   => 'absent',
#    provider => 'git',
#    source   => 'https://git.code.sf.net/p/dhcpd-pools/code',
#    revision => 'master',
#  }


  class { 'ipam': }
#  dns::key{"${::fqdn}":}
#  dns::tsig{'norman.openstack.tld':
  dns::tsig{'ipam0.rakops':
    ensure    => present,
    algorithm => 'hmac-md5',
    secret    => 'JFuV5v6ZHk1nJb6wlxrbCQ==',
    server    => $::ipaddress,
  }
}

