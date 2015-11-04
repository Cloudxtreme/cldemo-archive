class openstack::modprobe {
  exec { '/usr/bin/touch /tmp/puppet_once_lock_modprobe_bonding':
    creates => '/tmp/puppet_once_lock_modprobe_bonding',
    notify  => Exec['/sbin/modprobe bonding'],
  }

  exec { '/sbin/modprobe bonding':
    logoutput   => true,
    refreshonly => true,
    require     => Exec['/usr/bin/touch /tmp/puppet_once_lock_modprobe_bonding'],
  }
}
