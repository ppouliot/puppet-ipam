class hieratest {
  exec {"ipam_install_sample_hiera_and_apply_manifest":
    command => "/etc/puppet/modules/ipam/files/bootstrap.sh",
    cwd     => "/etc/puppet",
  }
}
