salt:
  lookup:
    minion:
      pkgs: False
      config:
        minion:
          config:
            master: 10.10.13.100
            log_level: debug

            module_dirs:
              - /srv/salt/_modules/common
              - /srv/salt/_modules/formulas

            states_dirs:
              - /srv/salt/_states/common
    master:
      pkgs: False
      config:
        master:
          config:
            autosign_file: /etc/salt/autosign.conf

            file_roots:
              base:
                - /srv/salt/states
                - /srv/salt/contrib/states
                - /vagrant/shared

            pillar_roots:
              base:
                - /srv/salt/pillar/examples
                - /srv/salt/pillar/shared

            reactor:
              - 'salt/minion/*/start':
                - /srv/salt/contrib/reactor/salt/files/basic.sls
              - 'salt/job/*/ret/*':
                - /srv/salt/contrib/reactor/salt/files/job_ret.sls
              - 'frontend/loadbalancer/pool/update':
                - /srv/salt/contrib/reactor/salt/files/lb_pool_update.sls
    cloud:
      config:
        cloud:
          config:
            pool_size: 10
            enable_hard_maps: true
cloud:
  update_cachedir: True
  diff_cache_events: True
  change_password: True
  providers:
    linode01:
      driver: linode
      password: s4ltcl0udl1n123
      ssh_key_file: /vagrant/shared/misc/salt-cloud/test-vagrant-salt-talk
  profiles:
    linode_2048_centos_fra:
      provider: linode01
      size: Linode 2048
      image: CentOS 7
      location: Frankfurt, DE
      script_args: -M -K -Z -P -D git 2015.5
      private_ip: true
#      minion:
#        master: li1371-29.members.linode.com
    linode_2048_debian_fra:
      provider: linode01
      size: Linode 2048
      image: Debian 7
      location: Frankfurt, DE
      script_args: -M -K -Z -P -D git 2015.5
      private_ip: true
    linode_2048_gentoo_fra:
      provider: linode01
      size: Linode 2048
      image: Gentoo 2014.12
      location: frankfurt
      script_args: -M -K -Z -P -D git 2015.5
      private_ip: true
    linode_2048_fedora_fra:
      provider: linode01
      size: Linode 2048
      image: Fedora 22
      location: frankfurt
      script_args: -M -K -Z -P -D git 2015.5
      private_ip: true
    linode_2048_arch_fra:
      provider: linode01
      size: Linode 2048
      image: Arch Linux 2015.02
      location: Frankfurt, DE
      script_args: -M -K -Z -P -D git 2015.5
      private_ip: true
    linode_2048_opensuse_fra:
      provider: linode01
      size: Linode 2048
      image: openSUSE 13.2
      location: frankfurt
      script_args: -M -K -Z -P -D git 2015.5
      private_ip: true
