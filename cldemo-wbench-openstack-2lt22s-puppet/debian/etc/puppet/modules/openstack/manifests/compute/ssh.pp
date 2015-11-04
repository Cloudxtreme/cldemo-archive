class openstack::compute::ssh {
  file { '/etc/ssh/sshd_config':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/openstack/sshd_config',
    notify  => Service['ssh'],
  }

  service { 'ssh':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
