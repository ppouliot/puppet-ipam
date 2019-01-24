require 'spec_helper'
describe 'ipam::install' do
  let(:pre_condition) { 'include ::ipam' }
  let(:node) { 'ipam1.contoso.ltd' }
  let(:facts) { { is_virtual: false } }

  on_supported_os.reject { |_, f| f[:os]['family'] == 'Solaris' }.each do |os, f|
    context "on #{os}" do
      let(:facts) do
        f.merge(super())
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('dns::server') }
      it { is_expected.to contain_class('dhcp') }
      it { is_expected.to contain_package('ntpdate') }
      it { is_expected.to contain_package('dhcping') }
      case f[:os]['family']
      when 'Debian'
        ['dnsutils', 'perl-doc', 'libnetaddr-ip-perl', 'libnet-snmp-perl'].each do |package|
          it { is_expected.to contain_package(package).only_with_ensure('latest') }
        end
        it { is_expected.to contain_package('apparmor').with_ensure('absent') }
        it {
          is_expected.to contain_exec('untar-dhcpstatus_0.60-lib')
            .with(
              command: '/bin/tar -xvf /opt/dhcpstatus_0.60/libraries.tar',
              cwd: '/usr/local/dhcpstatus',
              creates: [
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
              onlyif: '/usr/bin/test ! -f /usr/local/dhcpstatus/dhcpstatus/common.pm',
              logoutput: true,
              require: 'Archive[/opt/staging/dhcpstatus_0.60.tar.gz]',
            )
        }

      when 'RedHat'
        it { is_expected.to contain_class('epel') }
        ['bind-utils', 'perl-DB_File', 'perl-NetAddr-IP', 'bind-pkcs11-utils', 'net-snmp'].each do |package|
          it {
            is_expected.to contain_package(package)
              .with(
                ensure: 'latest',
                require: 'Class[Epel]',
              )
          }
        end
        it { is_expected.to contain_class('selinux').with(mode: 'disabled') }
        it {
          is_expected.to contain_service('polkit')
            .with(
              ensure: 'stopped',
              enable: 'false',
            )
        }
        it {
          is_expected.to contain_dns__server__options('/etc/named/named.conf.options')
            .with(
              listen_on_port: '53',
              allow_recursion: ['any'],
            )
        }
        it {
          is_expected.to contain_exec('untar-dhcpstatus_0.60-lib')
            .with(
              command: '/usr/bin/tar -xvf /opt/dhcpstatus_0.60/libraries.tar',
              cwd: '/usr/local/dhcpstatus',
              creates: [
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
              onlyif: '/usr/bin/test ! -f /usr/local/dhcpstatus/dhcpstatus/common.pm',
              logoutput: true,
              require: 'Archive[/opt/staging/dhcpstatus_0.60.tar.gz]',
            )
        }
      else
        it { expect { catalog }.to raise_error }
      end
      it { is_expected.to contain_file('/root/ipam_min_validate.sh') }
      it { is_expected.to contain_file('/root/create_omapi_key.sh') }
      it {
        is_expected.to contain_archive('/opt/staging/dhcpd-pool-0.2.tar.gz')
          .with(
            source: 'http://folk.uio.no/trondham/software/dhcpd-pool-0.2.tar.gz',
            extract: true,
            extract_path: '/opt',
          )
      }
      it {
        is_expected.to contain_archive('/opt/staging/dhcpd-pools-2.29.tar.xz')
          .with(
            source: 'https://downloads.sourceforge.net/project/dhcpd-pools/dhcpd-pools-2.29.tar.xz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fdhcpd-pools%2Ffiles%2F&ts=1510685804&use_mirror=gigenet',
          )
      }
      it {
        is_expected.to contain_archive('/opt/staging/dhcpstatus_0.60.tar.gz')
          .with(
            source: 'http://downloads.sourceforge.net/project/dhcpstatus/dhcpstatus/v0.60/dhcpstatus_0.60.tar.gz?r=http%3A%2F%2Fdhcpstatus.sourceforge.net%2F&ts=1480997571&use_mirror=pilotfiber',
            extract: true,
            extract_path: '/opt',
          )
      }
      it { is_expected.to contain_file('/usr/local/dhcpstatus') }
      it { is_expected.to contain_file('/usr/local/dhcpstatus/dhcpstatus.ini') }
      it {
        is_expected.to contain_vcsrepo('/opt/dhcpd-snmp')
          .with(
            ensure: 'latest',
            provider: 'git',
            source: 'https://github.com/ohitz/dhcpd-snmp',
            revision: 'master',
          )
      }
    end
  end
end
