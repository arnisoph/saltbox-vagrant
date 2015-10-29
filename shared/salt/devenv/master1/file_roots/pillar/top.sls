base:
  'minion* or master*':
    - match: compound
    - common
    #- private
    - salt
    - zsh

  'E@cloudmaster* or E@fe* or E@mw* or E@db*':
    - match: compound
    - orchestration.common
    #- orchestration.private
    - zsh

  'E@mw[0-9]+':
    - match: compound
    - orchestration.node

  'E@db[0-9]+':
    - match: compound
    - orchestration.redis
