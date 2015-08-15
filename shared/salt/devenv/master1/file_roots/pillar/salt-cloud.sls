salt:
  lookup:
    minion:
      config:
        minion:
          config:
            master: 127.0.0.1
            file_roots:
              base:
                - /srv/salt/states
                - /srv/salt/contrib/states
                - /vagrant/shared

            pillar_roots:
              base:
                - /srv/salt/pillar/examples
                - /srv/salt/pillar/shared

            module_dirs:
              - /srv/salt/_modules/common
              - /srv/salt/_modules/formulas

            states_dirs:
              - /srv/salt/_states/common
    cloud:
      config:
        cloud:
          config:
            pool_size: 15
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
    linode_1024_centos_fra:
      provider: linode01
      size: Linode 1024
      image: CentOS 7
      location: Frankfurt, DE
      script_args: -M -K stable
      private_ip: true
      minion:
        master: li1371-29.members.linode.com
    linode_1024_debian_fra:
      provider: linode01
      size: Linode 1024
      image: Debian 7
      location: Frankfurt, DE
      script_args: -M -K stable
      private_ip: true
      minion:
        master: li1371-29.members.linode.com
    linode_1024_gentoo_fra:
      provider: linode01
      size: Linode 1024
      image: Gentoo 2014.12
      location: frankfurt
      script_args: -M -K stable
      private_ip: true
      minion:
        master: li1371-29.members.linode.com
    linode_1024_fedora_fra:
      provider: linode01
      size: Linode 1024
      image: Fedora 22
      location: frankfurt
      script_args: -M -K stable
      private_ip: true
      minion:
        master: li1371-29.members.linode.com
    linode_1024_arch_fra:
      provider: linode01
      size: Linode 1024
      image: Arch Linux 2015.02
      location: Frankfurt, DE
      script_args: -M -K stable
      private_ip: true
      minion:
        master: li1371-29.members.linode.com
    linode_1024_opensuse_fra:
      provider: linode01
      size: Linode 1024
      image: openSUSE 13.2
      location: frankfurt
      script_args: -M -K stable
      private_ip: true
      minion:
        master: li1371-29.members.linode.com
