# For some reason rabbitmq fails to properly set its password
class openstack::controller::rabbitmq::refresh {

  exec { '/usr/bin/touch /tmp/puppet_once_lock_rabbitmq_refresh':
    creates => '/tmp/puppet_once_lock_rabbitmq_refresh',
    notify  => Exec['/usr/sbin/rabbitmqctl change_password guest cn321'],
  }

  exec { '/usr/sbin/rabbitmqctl change_password guest cn321':
    user        => 'root',
    refreshonly => true,
    logoutput   => true,
    require     => Exec['/usr/bin/touch /tmp/puppet_once_lock_rabbitmq_refresh'],
    notify      => Exec['/usr/sbin/service rabbitmq-server restart'],
  }

  #this hack is because refreshing the service causes a loop between stages since the service is in the main stage
  # yes, it's awful

  exec { '/usr/sbin/service rabbitmq-server restart':
    user        => 'root',
    refreshonly => true,
    require     => Exec['/usr/sbin/rabbitmqctl change_password guest cn321'],
  }
}
