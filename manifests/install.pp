# ipam::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include ipam::install
class ipam::install {

  case $::osfamily {
    'Debian':{
      $prereq_packages = [
      'dnsutils',
      'perl-doc',
      'libnetaddr-ip-perl',
      'libnet-snmp-perl',
      'ntpdate',
#      'bind-pkcs11-utils',
      ]
      $tar = '/bin/tar'

      notice("**** ${::osfamily} uses Apparmor *************************************************")
      notice("**** ${::osfamily} Apparmor will be uninstalled **********************************")
      # Remove Apparmor
      package {'apparmor':
        ensure => absent,
      }
    }
    'RedHat':{
      $prereq_packages = [
      'bind-utils',
      'perl-DB_File',
      'perl-NetAddr-IP',
      'bind-pkcs11-utils',
      'net-snmp',
      'ntpdate',
      ]
      $tar = '/usr/bin/tar'
      # Adding Epel Repos for dhcping
      include epel
      Package{ require => Class['epel'], }
      notice("**** ${::osfamily} uses SeLinux **************************************************")
      notice("**** ${::osfamily} running 'setsebool -P named_write_master_zones true' works ****")
      case $::virtual {
        'docker':{
          notice("**** ${::osfamily} in docker does not require selinux ****************************")
        }
        default:{
          notice("**** ${::osfamily} attempting to disable selinux via the selinux module **********")
          # Disable SELinux
          class{'::selinux':
            mode => 'disabled',
          }
          service{'polkit':
            ensure => stopped,
            enable => false,
          }
#         package{'polkit':
#           ensure => absent,
#         } notice("Removing Policy kit on ${::osfamily}")
        }
      }
    }
    default:{
      warning("${::fqdn} is using an unsupported platform prerequisit packaging will not function properly.")
    }
  }

  file{'/root/ipam_min_validate.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    content => '#!/usr/bin/env bash
echo "**** Verifying that the ISC-DHCP-SERVER Configuration ****"
/usr/sbin/dhcpd -t
echo "**** Verifying that the BIND Configuration ****"
/usr/sbin/named-checkconf',
  }
  file{'/root/create_omapi_key.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0777',
    source => 'puppet:///modules/ipam/create_omapi.sh',
  }

  package{ $prereq_packages:
    ensure => latest,
  }
  package{'dhcping':
    ensure => latest,
  }
  # dhcpd-pool 
  # script for generating dhcpd monitoring information 
  # More information on usage
  # http://folk.uio.no/trondham/software/dhcpd-pool.html

  archive{'/opt/staging/dhcpd-pool-0.2.tar.gz':
    source       => 'http://folk.uio.no/trondham/software/dhcpd-pool-0.2.tar.gz',
    extract      => true,
    extract_path => '/opt',
    require      => Package[$prereq_packages],
  }
  archive{'/opt/staging/dhcpd-pools-2.29.tar.xz':
    source => 'https://downloads.sourceforge.net/project/dhcpd-pools/dhcpd-pools-2.29.tar.xz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fdhcpd-pools%2Ffiles%2F&ts=1510685804&use_mirror=gigenet',
  }
  archive{'/opt/staging/dhcpstatus_0.60.tar.gz':
    source       => 'http://downloads.sourceforge.net/project/dhcpstatus/dhcpstatus/v0.60/dhcpstatus_0.60.tar.gz?r=http%3A%2F%2Fdhcpstatus.sourceforge.net%2F&ts=1480997571&use_mirror=pilotfiber',
    extract      => true,
    extract_path => '/opt',
    require      => Package[$prereq_packages],
  }
  file{'/usr/local/dhcpstatus':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }
->exec{'untar-dhcpstatus_0.60-lib':
    command   => "${tar} -xvf /opt/dhcpstatus_0.60/libraries.tar",
    cwd       =>'/usr/local/dhcpstatus',
    creates   => [
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
    require   =>  Archive['/opt/staging/dhcpstatus_0.60.tar.gz'],
  }
-> file{'/usr/local/dhcpstatus/dhcpstatus.ini':
    ensure  => file,
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

  # Install DNS Server
#  include dns::server
  class{'dns::server':
    enable_default_zones => false,
  }

  if $::osfamily == 'Redhat' {
    dns::server::options{'/etc/named/named.conf.options':
      listen_on_port  => '53',
      allow_recursion => ['any'],
    }
  }

  if $ipam::master == !false {
  #    @dns::key{ $::ddnskey: }
    notice('Ipam Master Hiera Value Found')
  }

  class { 'dhcp':
    dnsdomain   => hiera('dhcp::dnsdomain'),
    nameservers => hiera('dhcp::nameservers'),
    ntpservers  => hiera('dhcp::ntpservers'),
    interfaces  => hiera('dhcp::interfaces'),
#   dnsupdatekey => hiera('dhcp::dnsupdatekey',undef),
#   require      => Dns::Key[$ddnskey],
  }

  if ($dhcp::omapi_key){

    dns::tsig { 'omapi_key':
      ensure    => present,
      algorithm => 'hmac-md5',
      secret    => hiera('dhcp::omapi_key'),
      server    => $::ipam::server_interface,
    }
  }

  if ($ipam::dhcp_use_failover) {
    class {'dhcp::failover':
      role         => hiera('dhcp::failover::role'),
      peer_address => hiera('dhcp::failover::peer_address'),
    }
    Dhcp::Pool{ failover => 'dhcp-failover' }
  }

}
