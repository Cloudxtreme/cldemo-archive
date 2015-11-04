class openstack::portsconf ($switchtype='') {
  if $switchtype == '40G' {
    file { '/etc/cumulus/ports.conf':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/openstack/40G.conf',
      notify => Service['switchd'],
    }
  }
}

