class openstack::controller::keystone {

  mysql::db { 'keystone':
    user     => 'keystone',
    password => 'cn321',
    host     => '%',
    grant    => 'ALL',
  }->

  package { 'keystone':
    ensure => installed,
  } ->

  service { 'keystone':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['keystone'],
  }

  file { '/etc/keystone/keystone.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/openstack/keystone.conf',
    require => Package['keystone'],
    notify  => Service['keystone'],
  }

  file { '/var/lib/keystone/keystone.db':
    ensure  => absent,
    require => Package['keystone'],
  }



  file { '/home/cumulus/admin-openrc.sh':
    ensure => present,
    mode   => '0777',
    owner  => 'cumulus',
    group  => 'cumulus',
    source => 'puppet:///modules/openstack/admin-openrc.sh',
  }

  file { '/home/cumulus/demo-openrc.sh':
    ensure => present,
    mode   => '0777',
    owner  => 'cumulus',
    group  => 'cumulus',
    source => 'puppet:///modules/openstack/demo-openrc.sh',
  }
}
