class openstack::controller::keystone::create_endpoints {

  class { 'keystone::roles::admin':
    email               => 'ce-ceng@cumulusnetworks.com',
    password            => 'adminpw',
    admin_tenant        => 'admin',
    service_tenant      => 'service',
    require             => Service['keystone'],
  }->
  class { '::openstack::controller::keystone::user':
    email            => 'ce-ceng@cumulusnetworks.com',
    password         => 'demopw',
    user             => 'demo',
    user_tenant      => 'demo',
    user_tenant_desc => 'Puppet created demo tenant',
    require          => Service['keystone'],
  }->
  keystone_service { 'keystone':
    ensure      => present,
    type        => 'identity',
    description => 'OpenStack Identity Service',
  }->

  keystone_endpoint { "regionOne/keystone":
    ensure       => present,
    public_url   => 'http://192.168.0.201:5000/v2.0',
    admin_url    => 'http://192.168.0.201:35357/v2.0',
    internal_url => 'http://192.168.0.201:5000/v2.0',
    region       => 'regionOne',
  }->
  keystone_user { 'glance':
    ensure      => present,
    enabled     => true,
    tenant      => 'service',
    email       => 'ce-ceng@cumulusnetworks.com',
    password    => 'cn321'
  }->

  keystone_user_role { 'glance@service':
    ensure => present,
    roles  => [ '_member_', 'admin'],
  }->

  keystone_service { 'glance':
    ensure      => present,
    type        => 'image',
    description => 'OpenStack Image Service',
  }

  keystone_endpoint { "regionOne/glance":
    ensure       => present,
    public_url   => 'http://192.168.0.201:9292',
    admin_url    => 'http://192.168.0.201:9292',
    internal_url => 'http://192.168.0.201:9292',
    region       => 'regionOne',
    #notify       => [ Service['glance-registry'], Service['glance-api'] ],
  }

  keystone_user { 'nova':
    ensure      => present,
    enabled     => true,
    tenant      => 'service',
    email       => 'ce-ceng@cumulusnetworks.com',
    password    => 'cn321',
  }->

  keystone_user_role { 'nova@service' :
    ensure => present,
    roles  => [ '_member_', 'admin'],
  }->

  keystone_service { 'nova':
    ensure      => present,
    type        => 'compute',
    description => 'OpenStack Compute',
  }->

  keystone_endpoint { "regionOne/nova":
    ensure       => present,
    public_url   => 'http://192.168.0.201:8774/v2/%(tenant_id)s',
    admin_url    => 'http://192.168.0.201:8774/v2/%(tenant_id)s',
    internal_url => 'http://192.168.0.201:8774/v2/%(tenant_id)s',
    region       => 'regionOne',
    require      => Keystone_user['nova'],
    #     notify       => Service[ ['nova-api',
    #                       'nova-cert',
    #                       'nova-consoleauth',
    #                       'nova-scheduler',
    #                       'nova-conductor',
    #                       'nova-novncproxy',
    #                       'nova-compute', ] ],
    #
  }
}
