class openstack::quagga {
    service { 'quagga':
        ensure    => running,
        hasstatus => false,
        enable    => true,
    }

    file { '/etc/quagga/daemons':
        owner  => quagga,
        group  => quagga,
        source => 'puppet:///modules/openstack/quagga_daemons',
        notify => Service['quagga']
    }

    file { '/etc/quagga/Quagga.conf':
        owner   => root,
        group   => quaggavty,
        mode    => '0644',
        source  => "puppet:///modules/openstack/Quagga.conf_${::hostname}",
        notify  => Service['quagga']
    }
}
