class openstack::role::controller {

  include stdlib::stages,
    openstack::controller::nova,
    openstack::compute::ssh

  class { '::mysql::server':
    #NOTE: this password is insecure. do not put real production passwords inline
    root_password                => 'cn321',
    remove_default_accounts      => true,
    override_options             => {
      'mysqld'                   => {
        'bind_address'           => '192.168.0.201',
        'default-storage-engine' => 'innodb',
        'innodb_file_per_table'  => '1',
        'collation-server'       => 'utf8_general_ci',
        'init-connect'           => "'SET NAMES utf8'",
        'character-set-server'   => 'utf8',
      }
    },
    stage => 'setup',
  }

  class { 'openstack::controller::mysqlextras':
    stage => 'setup',
  }
  # a lot of the openstack service install requires mysql and mysql needs restarting after running
  # or else the class does not properly restart the server after change my.cnf
  package { [ 'vim' ] :
      ensure  => installed,
    } ->

    class { '::rabbitmq':
      default_user       => 'guest',
      default_pass       => 'cn321',
      config_variables   => {
        'loopback_users' => '[ ]'
      }
      } ->

    class { 'openstack::controller::keystone': }

    class { 'openstack::controller::glance': }

    class { 'openstack::controller::rabbitmq::refresh':
      stage =>  'runtime',
    }->
    class { 'openstack::controller::db_sync':
      stage => 'runtime',
    }
    class { 'openstack::controller::keystone::create_endpoints':
      stage => 'setup_infra',
    }

    class { 'openstack::controller::image_add':
      stage => 'deploy_infra',
    }->
    class { 'openstack::controller::horizon':
      stage => 'deploy_infra',
    }
    class { 'openstack::controller::network':
      stage => 'setup_app',
    }
}
