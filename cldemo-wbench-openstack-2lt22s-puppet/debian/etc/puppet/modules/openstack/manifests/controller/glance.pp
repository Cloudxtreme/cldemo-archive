class openstack::controller::glance {

  mysql::db { 'glance':
    user     => 'glance',
    password => 'cn321',
    host     => '%',
    grant    => 'ALL',
  } ->
  package { [ 'glance', 'python-glanceclient' ]:
    ensure => present
  }

  file { '/etc/glance/':
    ensure  => directory,
    owner   => 'glance',
    group   => 'root',
    mode    => '0775',
    require => Package['glance'],
  }

  file { '/var/lib/glance/glance.sqlite':
    ensure => absent,
  }

  file { [ '/etc/glance/glance-api-paste.ini',
          '/etc/glance/glance-cache.conf' ]:
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0644',
    require => Package['glance'],
    notify  => Service['glance-api'],
  }

  file { '/etc/glance/glance-api.conf':
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0644',
    source  => 'puppet:///modules/openstack/glance-api.conf',
    require => Package['glance'],
    notify  => Service['glance-api'],
  }

  service { 'glance-api':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['glance']
  }

  service { 'glance-registry':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['glance']
  }

  file { '/etc/glance/glance-registry.conf':
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0644',
    source  => 'puppet:///modules/openstack/glance-registry.conf',
    require => Package['glance'],
    notify  => Service['glance-registry'],
  }
}
