class rabbitmq {

  Class['yum'] -> Class['rabbitmq']

  package { 'erlang':
    ensure  => installed,
    require => Yumrepo['erlang'],
  }

  package { 'rabbitmq-server':
    source   => 'http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.1/rabbitmq-server-2.8.1-1.noarch.rpm',
    provider => 'rpm',
    ensure   => installed,
    require  => Package['erlang'],
  }

  file { '/etc/rabbitmq/rabbitmq.config':
    ensure  => present,
    content => template('rabbitmq/rabbitmq.conf.erb'),
    require => Package['rabbitmq-server'],
  }

  exec { 'enable-stomp':
    command => '/usr/sbin/rabbitmq-plugins enable rabbitmq_stomp',
    unless  => '/usr/sbin/rabbitmq-plugins list stomp | /bin/grep \[E\]',
    require => Package['rabbitmq-server'],
    notify  => Service['rabbitmq-server'],
  }

  exec { 'add-mcollective-user':
    command => '/usr/sbin/rabbitmqctl add_user mcollective mcollective',
    unless  => '/usr/sbin/rabbitmqctl list_users | /bin/grep mcollective',
    require => Service['rabbitmq-server'],
  }

  exec { 'add-user-permissions':
    command => '/usr/sbin/rabbitmqctl set_permissions -p / mcollective "^amq.gen-.*" ".*" ".*"',
    unless  => '/usr/sbin/rabbitmqctl list_user_permissions mcollective | /bin/grep amq.gen',
    require => Exec['add-mcollective-user'],
  }

  exec { 'open-firewall':
    command => '/sbin/iptables -I RH-Firewall-1-INPUT 1 -d 33.33.33.10 -p tcp --dport 6163 -j ACCEPT',
    unless  => '/sbin/iptables -L | /bin/grep dpt:pscribe',
  }

  service { 'rabbitmq-server':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [Package['rabbitmq-server'], File['/etc/rabbitmq/rabbitmq.config']],
    subscribe  => File['/etc/rabbitmq/rabbitmq.config']
  }
}
