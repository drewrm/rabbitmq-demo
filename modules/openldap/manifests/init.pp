class openldap {
  
  $root_password = "{SSHA}UGnfy8MiLHCK9PviDcW6BnFkC7cvzUcO" #password

  package { ['openldap-servers', 'openldap-clients', 'nss_ldap']:
    ensure => installed,
  }

  file { '/var/lib/ldap/DB_CONFIG':
    ensure  => present,
    owner   => 'root',
    group   => 'ldap',
    mode    => 0640,
    content => template('openldap/DB_CONFIG.erb'),
    require => Package['openldap-servers'],
  }

  file { '/etc/openldap/slapd.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'ldap',
    mode    => 0640,
    content => template('openldap/slapd.conf.erb'),
    require => Package['openldap-servers'],
  }

  file { '/var/lib/ldap/ldif':
    ensure  => present,
    content => template('openldap/ldif.erb'),
    require => Package['openldap-servers'],
  }

  exec { 'import-ldiff':
    command => "/usr/bin/ldapadd -a -x -D 'cn=admin,dc=vagrant,dc=internal' -f /var/lib/ldap/ldif -w password",
    unless  => "/usr/bin/ldapsearch -h localhost -x -b 'dc=vagrant,dc=internal' cn=admin",
    require => File['/var/lib/ldap/ldif'],
  }

  exec { 'open-firewall':
    command => '/sbin/iptables -I RH-Firewall-1-INPUT 1 -d 33.33.33.11 -p tcp --dport 389 -j ACCEPT',
    unless  => '/sbin/iptables -L | /bin/grep dpt:ldap',
  }

  service { 'ldap':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => File['/var/lib/ldap/DB_CONFIG', '/etc/openldap/slapd.conf'],
  }
}
