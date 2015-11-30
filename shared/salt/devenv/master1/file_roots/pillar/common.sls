httpd:
  hosts:
    - addr: 10.10.13.1
      allow: True
    - addr: 127.0.0.1
      allow: True
    - addr: 10.10.13.100
      allow: True
    - addr: 10.10.13.2

tomcat:
  lookup:
    instances:
      i1:
        id: 1
        cur_version: 8.0.20
        source: 'salt://misc/apache-tomcat-8.0.20.tar.gz'
        source_hash: md5=9a3dacfbe9644d7a23699b4aa9f648df
        versions:
          '8_0_20':
            version: 8.0.20
            settings:
              users:
                plain: |
                  <role rolename="manager"/>
                  <user username="admin" password="admin" roles="manager-gui"/>
                  <user username="deploy" password="admin" roles="manager-script,manager-gui"/>
                  <user username="tomcat-salt" password="tomcat-salt-user-password42" roles="manager-script,manager-gui"/>
            files:
              manage:
                - setenv
                - server
                - tomcat_users
                - init
              setenv:
                contents: |
                  export \
                  JAVA_OPTS="-Xms128m -Xmx128m" \
                  JAVA_HOME=/opt/java/jdk/current/src/ \
                  JAVA_OPTS="\
                    -Djava.net.preferIPv4Stack=true \
                    -Dhudson.DNSMultiCast.disabled=true \
                    "
              init:
                path: /etc/init.d/tomcat-i1
            webapps:
              docs:
                manage: True
                ensure: absent
              examples:
                manage: True
                ensure: absent
              host_manager:
                alias: host-manager
                manage: True
                ensure: absent
              manager:
                manage: False
              ROOT:
                manage: True
                ensure: absent
              jenkins:
                manage: True
                war:
                  deployment_type: manager
                  url: 'http://127.0.0.1:18080/manager'
                  source: 'salt://misc/jenkins.war'
                  #source: 'http://mirrors.jenkins-ci.org/war/latest/jenkins.war'
                  source_hash: sha512=c742ee5c4c3bdd37a12a7e5f78575171cd88e98d72b0f9f6e8b71f7375c8f61fdee57fba366e6b6b2a17492019f0af8a9e10688b47ed5fdff36573c89ca3762c
tomcat-manager:
  user: tomcat-salt
  passwd: tomcat-salt-user-password42

users:
  manage:
    tomcat:
      home: /var/lib/tomcat
      shell: /bin/false
      system: True
      groups:
        - tomcat

groups:
  manage:
    tomcat:
      system: True

java:
  lookup:
    manage:
      jdk:
        current_ver: 8u40
        versions:
          8u40:
            source: salt://misc/jdk-8u40-linux-x64.tar.gz
            version: jdk1.8.0_40

role: webserver

sysctl:
  lookup:
   params:
      - name: vm.swappiness
        value: 1

tools:
  lookup:
    tools:
      bzip:
        ensure: installed
#      colordiff:
#        ensure: installed
      curl:
        ensure: installed
      ed:
        ensure: installed
      gzip:
        ensure: installed
      htop:
        ensure: installed
      less:
        ensure: installed
      moreutils:
        ensure: installed
      rsync:
        ensure: installed
      sed:
        ensure: installed
      tar:
        ensure: installed
      traceroute:
        ensure: installed
      tree:
        ensure: installed
      tzdata:
        ensure: installed
      unzip:
        ensure: installed
      wget:
        ensure: installed
      zip:
        ensure: installed
