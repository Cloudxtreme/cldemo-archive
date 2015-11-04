class openstack::controller::horizon {

  package { ['apache2', 'memcached', 'libapache2-mod-wsgi', 'openstack-dashboard']:
    ensure => installed,
  }

  package { 'openstack-dashboard-ubuntu-theme':
    ensure  => purged,
    require => Package['openstack-dashboard'],
  }

  service {'apache2':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['apache2'],
  }

  service {'memcached':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['memcached'],
  }

  file {'/etc/openstack-dashboard/local_settings.py':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/openstack/local_settings.py',
    require => Package['openstack-dashboard'],
    notify  => Service['apache2'],
  }

}

