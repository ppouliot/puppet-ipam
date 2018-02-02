# include ipam
Service{
  provider => dummy
} ->
class { 'ipam': }
