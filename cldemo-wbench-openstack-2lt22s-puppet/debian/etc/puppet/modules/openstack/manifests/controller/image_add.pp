class openstack::controller::image_add {

  exec { '/usr/bin/touch /tmp/puppet_once_lock_glance_cirros':
    creates => '/tmp/puppet_once_lock_glance_cirros',
    notify  => Exec['glance_cirros'],
  }

  exec { 'glance_cirros':
    command     => '/usr/bin/glance  --os-username=admin --os-password=adminpw --os-tenant-name=admin --os-auth-url=http://192.168.0.201:35357/v2.0 image-create --name="Cirros" --disk-format=qcow2 --container-format=bare --is-public=true --copy-from http://cdn.download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img',
    logoutput   => true,
    user        => 'glance',
    refreshonly => true,
    require     => Exec['/usr/bin/touch /tmp/puppet_once_lock_glance_cirros'],
  }
}
