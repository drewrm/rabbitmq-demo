class yum {

  #dunno why this is here...
  file { '/etc/yum.repos.d/prosvc.repo':
    ensure => absent,
  }

  yumrepo { 'epel':
    mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch',
    name       => 'epel',
    enabled    => 1,
    gpgkey     => 'https://fedoraproject.org/static/217521F6.txt',
    require    => File['/etc/yum.repos.d/prosvc.repo'],
  }

  yumrepo { 'erlang':
    baseurl => 'http://repos.fedorapeople.org/repos/peter/erlang/epel-$releasever/$basearch/',
    enabled => 1,
    gpgcheck => 0,
    require => File['/etc/yum.repos.d/prosvc.repo'],
  }

  yumrepo { 'puppetlabs':
    baseurl  => "http://yum.puppetlabs.com/el/5Server/products/x86_64/",
    enabled  => 1,
    gpgcheck => 0,
    require    => File['/etc/yum.repos.d/prosvc.repo'],
  }
}
