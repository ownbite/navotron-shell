#!/bin/sh

mkdir -p /etc/puppet/modules
cd /etc/puppet 
ln -fs /vagrant/puppet/modules modules
