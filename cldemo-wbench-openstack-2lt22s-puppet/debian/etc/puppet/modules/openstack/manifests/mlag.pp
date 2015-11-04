class openstack::mlag ( $peer_ip = '', $sys_mac = '' ) {

  service { 'clagd':
    ensure    => running,
    hasstatus => true,
  }

  file { '/etc/default/clagd':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('openstack/clagd.erb'),
    notify  => Service['clagd'],
  }
}
