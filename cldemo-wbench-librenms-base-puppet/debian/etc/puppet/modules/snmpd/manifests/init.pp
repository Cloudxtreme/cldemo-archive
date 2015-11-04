# == Class: snmpd
# This module configures snmpd for the Cumulus switches involved in the librenms demo
#

class snmpd {

  service { 'snmpd' :
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['snmpd'],
  }

  package { 'snmpd' :
    ensure => installed,
  }

  package { 'snmp' :
    ensure => installed,
  }

  file { '/etc/default/snmpd' :
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/snmpd/snmpd',
    notify => Service['snmpd'],
  }

  file { '/etc/snmp/snmpd.conf' :
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/snmpd/snmpd.conf',
    notify => Service['snmpd'],
  }
}
