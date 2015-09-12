===============
saltbox-vagrant
===============

.. image:: https://img.shields.io/badge/donate-flattr-red.svg
    :alt: Donate via flattr
    :target: https://flattr.com/profile/bechtoldt

.. image:: https://img.shields.io/gratipay/bechtoldt.svg
    :alt: Donate via Gratipay
    :target: https://www.gratipay.com/bechtoldt/

.. image:: https://img.shields.io/badge/license-Apache--2.0-blue.svg
    :alt: Apache-2.0-licensed
    :target: https://github.com/bechtoldt/saltbox-vagrant/blob/master/LICENSE

.. image:: https://img.shields.io/badge/chat-gitter-brightgreen.svg
    :alt: Join Gitter Chat
    :target: https://gitter.im/bechtoldt/saltbox-vagrant?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge

.. image:: https://img.shields.io/badge/chat-%23salt%20@%20Freenode-brightgreen.svg
    :alt: Join Internet Relay Chat
    :target: http://webchat.freenode.net/?channels=%23salt&uio=d4

A Vagrant VM that uses SaltStack to setup a SaltStack sandbox for SaltStack demonstration

.. contents::
    :backlinks: none
    :local:


Requirements
------------

You need:

* basic vagrant knowledge (RTFM skills are sufficient)
* Vagrant >= 1.6.5 (``$ vagrant -v``)
* VirtualBox >= 3


Workflows
---------
Preparing Vagrant VM(s)
'''''''''''''''''''''''

Preparing the setup:

::

    # git clone --recursive https://github.com/bechtoldt/saltbox-vagrant.git saltbox
    # cd saltbox/
    # cp nodes.yaml.dist nodes.yaml
    # cd vagrant/
    # vagrant up master1
    # vagrant ssh master1
    $ sudo -i

Hint: To continue with full awesomeness, setup ZSH shell (see ``Misc`` section).

salt-call -l debug state.sls git,tools,zsh test=False


Installing Salt manually
''''''''''''''''''''''''

Hint: This is not needed when you haven't disabled ``saltstack_install_bootstrap`` in the file ``nodes.yaml``.

::

    # /vagrant/scripts/custom/saltstack_install_bootstrap/A_base.sh
    # /vagrant/scripts/custom/saltstack_config/A_base.sh
    # /vagrant/scripts/custom/saltstack_services/A_base.sh


Basics
''''''

Check Salt is installed:

::

    # salt-call test.version

Check Salt minion/ master configuration:

::

    # less /etc/salt/minion
    # less /etc/salt/master
    # tree -l /srv/salt/


Module Documentation
''''''''''''''''''''

Read the docs:

::

    # salt-call sys.doc
    # salt-call sys.doc pillar
    # salt-call sys.doc pillar.get


Job Managment
'''''''''''''

Add recurring jobs (like cronjobs) ad-hoc using the minion job scheduler:

::

    # salt-call schedule.add test_ping function='test.ping' seconds=10
    # salt-call schedule.add apply_states function='state.highstate' minutes=30
    # salt-call schedule.list

Manage arbitrary cron jobs:

::

    # salt-call cron.ls root


Software Package Management
'''''''''''''''''''''''''''

::

    # salt-call pkg.install rubygems
    # salt-call gem.install lolcat
    # salt-call pkg.list_upgrades | lolcat


Grains data
'''''''''''

See list of grains:

::

    # salt-call grains.items
    # salt-call grains.get os
    # salt-call grains.get os --out=json
    # salt-call grains.get os --out=yaml

Get minion OS statistics (requires a Salt master):

::

    # salt '*' grains.get os --out=yaml | cut -f2 -d' ' | sort | uniq -c | sort -nr


Pillar data
'''''''''''

See specific pillar data:

::

    # salt-call pillar.get users
    # salt-call pillar.get users --out=json


System User/Group management
''''''''''''''''''''''''''''

::

    # salt-call user.list_users
    # salt-call user.delete operator
    # salt-call user.info operator
    # salt-call user.add operator
    # salt-call user.info operator


Installing and Running a Webserver
'''''''''''''''''''''''''''''''''''

::

    # salt-call pkg.install httpd
    # salt-call pkg.version httpd
    # salt-call apache.modules
    # salt-call service.restart httpd
    # salt-call cmd.run 'curl -vs http://127.0.0.1'
    # salt-call cmd.run 'echo This is a test page > /var/www/html/index.html'
    # salt-call cmd.run 'curl -vs http://127.0.0.1'


Retreiving remote files
'''''''''''''''''''''''

::

    # salt-call cp.get_url http://slashdot.org/ /tmp/index.html
    # salt-call cmd.run 'head -20 /tmp/index.html'


Applying Salt States for software & configuration mgmt
''''''''''''''''''''''''''''''''''''''''''''''''''''''

Installing Apache httpd, deploying a httpd.conf template and restart the service afterwards:

::

    # salt-call -l debug state.sls saltbox.simple_apache_httpd test=True
    # salt-call -l debug state.sls saltbox.simple_apache_httpd
    # echo unwantend content >> /etc/httpd/conf/httpd.conf
    # salt-call -l debug state.sls saltbox.simple_apache_httpd

Doing the same as before but now making use of the Salt pillar system:

::

    # head /srv/salt/pillar/shared/common.sls
    # salt-call -l debug pillar.get httpd
    # salt-call -l debug pillar.get httpd --out=json
    # diff -u /srv/salt/states/saltbox/simple_apache_httpd/init.sls /srv/salt/states/saltbox/simple_apache_httpd_dynamic/init.sls
    # tail /srv/salt/contrib/states/saltbox/files/httpd_dynamic.conf
    # salt-call -l debug state.sls saltbox.simple_apache_httpd_dynamic test=True
    # salt-call -l debug state.sls saltbox.simple_apache_httpd_dynamic
    # curl -vs http://127.0.0.1/

Feel free to play around with Salt by modifying the files that you've found in ``/srv/salt/`` for hacking.


Adding custom Salt States
'''''''''''''''''''''''''

To develop and test self-written Salt pillar or state files simply store them in ``/srv/salt/pillar/shared/`` (Pillar) and ``/srv/salt/states/`` (States). The default minion/master configuration looks for pillar (``pillar_roots``) and state (``file_roots``) files within these folders.


Working with the master
'''''''''''''''''''''''

Use the master for job & file management:

::

    # ed -s /etc/salt/minion <<< $',s/file_client: local/master: 127.0.0.1/\nw'
    # service salt-minion restart

(``file_client: local`` needs to be replaced by ``master: 127.0.0.1``)


Minion key management:

::

    # salt-key
    # head /etc/salt/autosign.conf
    # salt-key -h

Targeting (specifying minions to execute commands):

::

    # salt -v 'master1.saltbox.local.inovex.de' test.version
    # salt -v 'master1*' test.version
    # salt -v -C 'G@os_family:RedHat' test.version
    # salt -v -C 'G@os_family:RedHat and I@role:webserver' test.version
    # salt -v -C '*' pillar.get role
    # salt -v -C '*' test.version

Executing some execution modules:

::

    # salt -v 'master1*' state.sls saltbox.simple_apache_httpd_dynamic test=True
    # salt -v 'master1*' pkg.install openssl refresh=True
    # salt -v 'master1*' pkg.list_upgrades
    # salt -v 'master1*' service.get_all
    # salt -v 'master1*' service.restart httpd
    # salt -v 'master1*' disk.usage
    # salt -v 'master1*' git.clone /tmp/github.clone git://github.com/bechtoldt/dotfiles.git; ls -al /tmp/github.clone/
    # salt -v 'master1*' grains.get os_family

Targeting minions based on hostnames, grains and more (requires some more minions):

::

    # salt -C 'E@minion[13-37]+' test.ping
    # salt -L 'minion42,master1,minion69' test.ping
    # salt -C 'G@os:CentOS' test.ping
    # salt -C 'G@os:Debian' test.ping
    # salt -C 'G@os:Arch' test.ping
    # salt -C 'S@139.162.209.0/24 and P@os:CentOS' test.ping
    # salt -C 'S@139.162.209.0/24 and P@os:CentOS' test.ping


Salt Cloud VM Deployment
''''''''''''''''''''''''

This doesn't work out of the box since you need provider API credentials to deploy *cloud* VMs.


Prepare the system for Salt Cloud:

::

    # Required states:
    # salt-call -ldebug state.sls salt.cloud,repos,git,tools

    # With optional states:
    # salt-call -ldebug state.sls salt.cloud,repos,git,tools,zsh,users,vim


List available DC locations of the provider defined in provider config linode01:

::

    # salt-cloud --list-locations=linode01

List available VM images of the provider defined in provider config linode01:

::

    # salt-cloud --list-images=linode01

Deploy a VM using the profile linode_2048_centos_fra and name it minion1:

::

    # salt-cloud -l debug -p linode_2048_centos_fra minion1

Deploy even more VMs:

::

    # salt-cloud --map /vagrant/shared/misc/salt-cloud/map1.yaml --parallel --hard

Destroy them all:

::

    # salt-cloud --map /vagrant/shared/misc/salt-cloud/map1.yaml --parallel --destroy --assume-yes


Misc
''''

Setup ZSH profile:

::

    # salt-call -l debug state.sls git,tools,zsh test=False
    # exit
    $ sudo -i


Update saltbox-vagrant VM(s)/ Git submodules:

::

    # cd saltbox/
    # git pull
    # git submodule update --init --recursive .


Additional resources
--------------------

See `Configuration Management with SaltStack <https://www.inovex.de/fileadmin/files/Vortraege/configuration-management-with-saltstack-arnold-bechtold-slac-2014.pdf>`_ for
slides that have some useful information.

Please see https://github.com/bechtoldt/vagrant-devenv for some more bits of information about the vagrant VM.

Alternative bootstrap arguments: ``-M -K -g https://github.com/saltstack/salt.git git 2014.7``

.. image:: https://asciinema.org/a/26271.png
       :target: https://asciinema.org/a/26271


TODO
----

see https://github.com/bechtoldt/saltbox-vagrant/issues
