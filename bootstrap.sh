#!/bin/sh


if [ ! -L '/etc/puppet/modules' ]; then
	echo "=> Creating a symlink to /vagrant/puppet/modules"
	mkdir -p /etc/puppet
	cd /etc/puppet 
	ln -fs /vagrant/puppet/modules modules
fi 


