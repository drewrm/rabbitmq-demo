class mcollective::client {

  Class['yum'] -> Class['mcollective']

  package { 'mcollective-client':
    ensure  => installed,
    require => Yumrepo['puppetlabs', 'epel'],
  }

  file { '/etc/mcollective/client.cfg':
    ensure  => present,
    content => template('mcollective/client.cfg.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => Package['mcollective-client'],
  }
}
