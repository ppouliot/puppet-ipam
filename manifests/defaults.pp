class bootstrap {

  package { 'r10k':
    ensure   => 'latest',
    provider => 'gem',
  }

  package { 'hiera-eyaml':
    ensure   => 'latest',
    provider => 'gem',
  }
