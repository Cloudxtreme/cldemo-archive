
class openstack::role::compute {
  include openstack::compute::ssh,
    openstack::compute::nova,
    stdlib::stages

  class { 'openstack::modprobe':
    stage => 'setup'
  }
}
