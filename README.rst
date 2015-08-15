===============
saltbox-vagrant
===============

A Vagrant VM that uses SaltStack to setup a SaltStack sandbox for SaltStack demonstration

.. contents::
    :backlinks: none
    :local:


Requirements
------------

You need:

* basic vagrant knowledge (RFTM skills are sufficient)
* Vagrant >= 1.6.5 (``$ vagrant -v``)


Workflows
---------
Basics
''''''

Preparing the setup:

::

    # git clone <GIT_URI> --recursive
    # cd vagrant/
    # vagrant up
    # vagrant ssh
    # sudo -i
    # /vagrant/scripts/custom/saltstack_install_bootstrap/A_base.sh
    # /vagrant/scripts/custom/saltstack_config/A_base.sh
    # /vagrant/scripts/custom/saltstack_services/A_base.sh

Alternative bootstrap arguments: ``-M -K -g https://github.com/saltstack/salt.git git 2014.7``

Check Salt is installed:

::

    # salt-call --local test.version

Check Salt minion/ master configuration:

::

    # less /etc/salt/minion
    # less /etc/salt/master
    # tree -l /srv/salt/

See list of grains:

::

    # salt-call --local grains.items

See specific pillar data:

::

    # salt-call --local pillar.get users
    # salt-call --local pillar.get users --out=json

Read the docs:

::

    # salt-call --local sys.doc
    # salt-call --local sys.doc pillar
    # salt-call --local sys.doc pillar.get


Simple Apache httpd Management
''''''''''''''''''''''''''''''

Installing Apache httpd, deploying a httpd.conf template and restart the service afterwards.

::

    # salt-call --local -l debug state.sls saltbox.simple_apache_httpd test=True
    # salt-call --local -l debug state.sls saltbox.simple_apache_httpd
    # echo unwantend content >> /etc/httpd/conf/httpd.conf
    # salt-call --local -l debug state.sls saltbox.simple_apache_httpd

The same as before but now making use of the Salt pillar system

::

    # less /srv/salt/pillar/share/common/init.sls
    # salt-call --local -l debug pillar.get httpd --out=json
    # diff -u /srv/salt/states/saltbox/simple_apache_httpd/init.sls /srv/salt/states/saltbox/simple_apache_httpd_dynamic/init.sls
    # less /srv/salt/contrib/states/saltbox/files/httpd_dynamic.conf
    # salt-call --local -l debug state.sls saltbox.simple_apache_httpd_dynamic test=True
    # curl -vs http://10.10.13.100/


Working with the master
'''''''''''''''''''''''

Minion key management:

::

    # salt-key
    # salt-key -D
    # service salt-minion restart
    # cat /etc/salt/autosign.conf
    # salt-key -h

Targeting:

::

    # salt 'master1.saltbox.local.inovex.de' test.version
    # salt 'master1*' test.version
    # salt -C 'G@os_family:RedHat' test.version
    # salt -C 'G@os_family:RedHat and I@role:webserver' test.version
    # salt -C '*' test.version

Executing some execution modules:

::

    # salt 'master1*' state.sls saltbox.simple_apache_httpd_dynamic test=True
    # salt 'master1*' pkg.install openssl refresh=True
    # salt 'master1*' pkg.list_upgrades
    # salt 'master1*' service.get_all
    # salt 'master1*' service.restart httpd
    # salt 'master1*' disk.usage
    # salt 'master1*' git.clone /tmp/github.clone git://github.com/saltstack/salt.git; ls -l /tmp/github.clone/
    # salt 'master1*' grains.get os_family


Misc
''''

Setup ZSH profile:

::

    # salt-call --local -l debug state.sls git,tools,zsh test=False; usermod -s /bin/zsh root


Additional resources
--------------------

See `Configuration Management with SaltStack <https://www.inovex.de/fileadmin/files/Vortraege/configuration-management-with-saltstack-arnold-bechtold-slac-2014.pdf>`_ for
slides that have some useful information.

Please see https://github.com/bechtoldt/vagrant-devenv for some more bits of information about the vagrant VM.


TODO
----

* chapters: security/ workflows (pkg install / service restart), lb.., failhard
