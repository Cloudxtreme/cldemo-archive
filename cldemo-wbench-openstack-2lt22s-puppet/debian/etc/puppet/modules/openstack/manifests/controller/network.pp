# creates openstack networks

class openstack::controller::network {

  file { '/tmp/network_create.sh':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/openstack/network_create.sh',
  }

  exec { '/usr/bin/touch /tmp/puppet_once_network_create':
    creates => '/tmp/puppet_once_network_create',
    notify  => Exec['network_create'],
    require => File['/tmp/network_create.sh'],
  }

  exec { 'network_create':
    command     => '/tmp/network_create.sh',
    logoutput   => true,
    refreshonly => true,
    require     => Exec['/usr/bin/touch /tmp/puppet_once_network_create'],
  }
}
