class vmware-demo::clag (
  $peer_if = '',
  $peer_ip = '',
  $sys_mac = '', ) {

    service { 'clagd':
      ensure     => running,
      hasstatus  => true,
      hasrestart => true,
    }

    file { '/etc/default/clagd':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('vmware-demo/clagd.erb'),
      notify  => Service['clagd'],
    }
}
