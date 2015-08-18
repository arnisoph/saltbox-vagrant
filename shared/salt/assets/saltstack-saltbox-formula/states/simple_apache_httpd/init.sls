#!jinja|yaml

httpd:
  pkg:
    - installed
  file:
    - managed
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://saltbox/files/httpd.conf
    - user: root
    - group: root
    - mode: 644
  service:
    - running
    - watch:
      - file: httpd
