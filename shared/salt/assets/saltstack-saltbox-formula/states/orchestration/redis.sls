redis:
  pkg:
    - installed
    - pkgs:
      - redis
  file:
    - managed
    - name: /etc/redis.conf
    - user: redis
    - group: redis
    - mode: 644
    - contents: |
        bind 0.0.0.0
    - watch_in:
      - service: redis
  service:
    - running
    - name: redis
    - enable: True
