#custom_modules:
#  git:
#    - latest
#    - name: https://github.com/bechtoldt/salt-modules
#    - rev: master
#    - target: /srv/salt-modules/

salt_minion:
  file:
    - managed
    - name: /etc/salt/minion
    - source: salt://saltbox/files/orchestration/minion
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - watch_in:
      - service: salt_minion
  service:
    - running
    - name: salt-minion
    - enable: True

minion_config_updated:
  event:
    - wait
    - name: custom/minion/config_updated
    - watch:
      - file: salt_minion
    - require:
      - service: salt_minion
