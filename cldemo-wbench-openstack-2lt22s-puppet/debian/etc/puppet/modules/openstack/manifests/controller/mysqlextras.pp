class openstack::controller::mysqlextras {
  # a lot of the openstack service install requires mysql and mysql needs restarting after running
  # or else the class does not properly restart the server after change my.cnf
  package { [ 'python-mysqldb' ] :
      ensure  => installed,
      require => Package['mysql-server'],
      notify  => Service['mysqld'],
    }
}
