class openstack::compute::nova {

  package { [ 'nova-compute-kvm',
              'vlan',
              'nova-network',
              'nova-api-metadata',
              'vim',
              'ifenslave' ] :
    ensure => installed,
  }

  file { '/etc/nova/nova.conf':
    ensure => present,
    owner  => 'nova',
    group  => 'nova',
    mode   => '0644',
    source => 'puppet:///modules/openstack/nova.conf.compute',
    notify => Service[ ['nova-compute', 'nova-network', 'nova-api-metadata'] ],
  }

  service { [ 'nova-compute', 'nova-network', 'nova-api-metadata' ]:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[ 'nova-compute-kvm' ],
  }

}
