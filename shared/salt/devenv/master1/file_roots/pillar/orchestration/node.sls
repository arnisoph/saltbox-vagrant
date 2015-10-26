repos:
  lookup:
    repos:
      node:
        url: https://rpm.nodesource.com/pub/el/7/$basearch
        keyurl: https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL
    #node_src:
    #    url: https://rpm.nodesource.com/pub/el/7/SRPMS

mine_functions:
  network_ip_addrs:
    mine_function: network.ip_addrs
    interface: eth0
