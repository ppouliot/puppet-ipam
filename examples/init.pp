# include ipam
if $virtual == 'docker' {
  include dummy_service
}
class { 'ipam': }
