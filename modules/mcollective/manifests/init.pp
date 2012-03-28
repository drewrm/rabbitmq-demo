class mcollective {

  Class['yum'] -> Class['mcollective']

  package { 'mcollective':
    ensure  => installed,
    require => Yumrepo['puppetlabs', 'epel'],
  }

  file { '/etc/mcollective/server.cfg':
    owner   => 'root',
    group   => 'root',
    mode    => 0640,
    ensure  => present,
    content => template('mcollective/server.cfg.erb'),
    require => Package['mcollective'],
  }

  service { 'mcollective':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => [Package['mcollective'], File['/etc/mcollective/server.cfg']],
    subscribe  => File['/etc/mcollective/server.cfg'],
  }
}
