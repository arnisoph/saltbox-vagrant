haste_server:
  npm:
    - installed
    - pkgs:
      - forever
  git:
    - latest
    - name: https://github.com/seejohnrun/haste-server
    - rev: master
    - target: /srv/haste-server/
  file:
    - serialize
    - name: /srv/haste-server/config.js
    - formatter: json
    #- dataset_pillar: haste:lookup:server:config
    - dataset:
        host: {{ salt['grains.get']('ip4_interfaces:eth0')[1] }}
        port: 7777
        keyLength: 10
        maxLength: 400000
        staticMaxAge: 86400
        recompressStaticAssets: true
        logging:
           - level: verbose
             type: Console
             colorize: true
        keyGenerator:
         type: phonetic
        storage:
         type: redis
         {# host: {  salt['publish.publish']('db*', 'grains.get', 'ip4_interfaces')['db1']['eth0'][1] } #}
         host: {{ salt['mine.get']('db*', 'network_ip_addrs')['db1'][1] }}
         port: 6379
         db: 2
         expire: 2592000
        documents:
         about: ./about.md
    - user: root
    - group: root
    - mode: 640
    - watch_in:
      - cmd: haste_server_npm_install

haste_server_npm_install:
  cmd:
    - wait
    - name: npm install
    - cwd: /srv/haste-server/

haste_server_service:
  cmd:
    - run
    - name: forever start -a -o /var/log/haste-server.log -e /var/log/haste-server-error.log server.js
    - unless: forever list | grep -q server.js
    - cwd: /srv/haste-server/

haste_server_started:
  event:
    - wait
    - name: custom/minion/haste_server_started
    - watch:
      - cmd: haste_server_service
#  module:
#    - wait
#    - name: smtp.send_msg
#    - kwargs:
#      subject: 'Hooray, a new app backend ({{ salt['grains.get']('id') }})!'
#      recipient: 'mail@arnoldbechtoldt.com'
#      message: 'Haste Server started on {{ salt['grains.get']('id') }} ({{ salt['grains.get']('fqdn') }})'
#      profile: smtp_credentials
#    - watch:
#      - cmd: haste_server_service
  module:
    - wait
    - name: http.query
    - url: https://api.mailgun.net/v3/sandboxa74098442634497f9f966ce1c262b672.mailgun.org/messages
    - kwargs:
        backend: requests
        method: POST
        data:
          from: salt@{{ salt['grains.get']('id') }}
          to: mail@arnoldbechtoldt.com
          subject: 'Hooray, a new app backend ({{ salt['grains.get']('id') }})!'
          text: 'Haste Server started on {{ salt['grains.get']('id') }} ({{ salt['grains.get']('fqdn') }})'
        username: api
        password: {{ salt['pillar.get']('mailgun_apikey') }}
        hide_fields: []
    - watch:
      - cmd: haste_server_service
