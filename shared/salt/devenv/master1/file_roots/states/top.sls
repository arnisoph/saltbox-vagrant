base:
  'minion* or master*':
    - match: compound
    - common
    - private
    - salt
    - zsh

  'master1*':
    - salt.master

  'E@cloudmaster* or E@fe* or E@mw* or E@db*':
    - match: compound
    - git
    - repos
    - tools
    - users
    - vim
    - zsh

  'E@fe[0-9]+':
    - match: compound
    - saltbox.orchestration.haproxy

  'E@mw[0-9]+':
    - match: compound
    - saltbox.orchestration.node
    - saltbox.orchestration.haste

  'E@db[0-9]+':
    - match: compound
    - saltbox.orchestration.redis
