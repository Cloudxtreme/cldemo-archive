class openstack::controller::keystone::user (
  $email                 = '',
  $password              = '',
  $user                  = 'user',
  $user_tenant           = 'openstack',
  $user_tenant_desc      = 'user tenant',
) {
  keystone_tenant { $user_tenant:
    ensure      => present,
    enabled     => true,
    description => $user_tenant_desc,
  }
  keystone_user { $user:
    ensure      => present,
    enabled     => true,
    tenant      => $user_tenant,
    email       => $email,
    password    => $password,
  }
  keystone_user_role { "${user}@${user_tenant}":
    ensure => present,
    roles  => '_member_',
  }
}
