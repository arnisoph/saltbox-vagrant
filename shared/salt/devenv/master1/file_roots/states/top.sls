base:
  'minion* or master*':
    - match: compound
    - common
    - private
    - salt
    - zsh

  'master1*':
    - salt.master
