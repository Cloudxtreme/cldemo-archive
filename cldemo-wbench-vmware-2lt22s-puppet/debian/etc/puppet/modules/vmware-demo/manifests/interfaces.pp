class vmware-demo::interfaces {
  file { '/etc/network/interfaces':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/vmware-demo/interfaces_${::hostname}"
  }

  if $::operatingsystem == 'CumulusLinux' {
    exec { '/sbin/ifreload -a':
        subscribe => File['/etc/network/interfaces'],
        refreshonly => true,
    }
  }
  else {
    exec { "/sbin/ifdown --exclude=lo -a && /sbin/ifup --exclude=lo -a":
        subscribe => File['/etc/network/interfaces'],
        refreshonly => true,
    }
  }
}

