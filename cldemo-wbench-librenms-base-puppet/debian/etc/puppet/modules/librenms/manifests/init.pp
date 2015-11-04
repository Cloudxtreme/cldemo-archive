# == Class: librenms
#
# This class installs & manages LibreNMS, a fork of Observium
#
# == Parameters
#
# [*config*]
#   Configuration for LibreNMS, in a puppet hash format.
#
# [*install_dir*]
#   Installation directory for LibreNMS. Defaults to /srv/librenms.
#
# [*rrd_dir*]
#   Location where RRD files are going to be placed. Defaults to "rrd" under
#   *install_dir*.
#
# Based on puppet from the Wikimedia Foundation

class librenms(
    $config=librenms::params::config,
    $install_dir='/var/www/librenms',
    $rrd_dir='/var/www/rrd',
) {
    include stdlib

    group { 'librenms':
        ensure => present,
    }

    user { 'librenms':
        ensure     => present,
        gid        => 'librenms',
        shell      => '/bin/false',
        home       => '/nonexistent',
        system     => true,
        managehome => false,
    }

    file { $install_dir:
        ensure  => directory,
        owner   => 'www-data',
        group   => 'librenms',
        require => Group['librenms'],
    }

    file { "${install_dir}/config.php":
        ensure  => present,
        owner   => 'www-data',
        group   => 'librenms',
        mode    => '0440',
        content => template('librenms/config.php.erb'),
        require => Group['librenms'],
    }

    file { $rrd_dir:
      ensure  => directory,
      owner   => 'www-data',
      group   => 'librenms',
      mode    => '0775',
      require => Group['librenms'],
    }

    file { "${install_dir}/librenms.cron":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      content => template('librenms/librenms.cron.erb'),
    }
      
    file { '/etc/cron.d/librenms':
      ensure  => link,
      target  => "${install_dir}/librenms.cron",
      require => File["${install_dir}/librenms.cron"],
    }

    file { '/etc/apache2/sites-available/librenms.conf':
        ensure  => present,
        owner   => 'www-data',
        group   => 'librenms',
        mode    => '0664',
        content => template('librenms/librenms.conf.erb'),
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/sites-enabled/librenms.conf':
      ensure  => link,
      owner   => 'www-data',
      group   => 'librenms',
      mode    => '0664',
      target  => '/etc/apache2/sites-available/librenms.conf',
      require => File['/etc/apache2/sites-available/librenms.conf'],
    }

  file { '/etc/apache2/sites-enabled/15-default.conf':
    ensure => absent,
    notify => Service['apache2']
  }

  file { '/etc/apache2/sites-enabled/000-default':
    ensure => absent,
    notify => Service['apache2']
  }

    package { [
            'apache2',
            'libapache2-mod-php5',
            'php5-cli',
            'php5-gd',
            'php5-common',
            'php5-mcrypt',
            'php5-mysql',
            'php5-snmp',
            'php-net-ipv4',
            'php-net-ipv6',
            'php-pear',
            'fping',
            'git',
            'graphviz',
            'imagemagick',
            'ipmitool',
            'mtr-tiny',
            'nmap',
            'python-mysqldb',
            'rrdtool',
            'snmp',
            'snmp-mibs-downloader',
            'snmpd',
            'whois',
        ]:
        ensure => present,
    }


  service { 'apache2':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['apache2'],
  }

    # syslog script, in an install_dir-agnostic location
    # used by librenms::syslog or a custom alternative placed manually.
    file { '/usr/local/sbin/librenms-syslog':
        ensure => link,
        target => "${install_dir}/syslog.php",

    }

  class { '::mysql::server':
    root_password   => 'password',
    service_enabled => true,
  }

  mysql::db { 'librenms':
    user     => 'librenms',
    password => 'password',
    host     => 'localhost',
    grant    => 'ALL',
  }

  class { 'librenms::configure':
    stage => runtime,
  }
}
