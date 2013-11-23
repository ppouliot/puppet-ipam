class hieratest {
  file {'/tmp/bootstrap.sh':
    ensure  => file,
    content => tempate('ipam/bootstrap.erb'),
    owner   => root,
    group   => root,
    mode    => "0777",
  }
  exec {"ipam_install_sample_hiera_and_apply_manifest":
    command => "/tmp/bootstrap.sh",
    cwd     => "/tmp",
  }
}
