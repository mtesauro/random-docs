#!/usr/bin/env bash

#
# Install OWASP WTE repo to add WebGoat to Hacking-lab VM
#

# Clear up an installed repo that is 404'ing
mkdir /root/cya
mv /etc/apt/sources.list.d/hacking-lab.list /root/cya/hacking-lab.list

# Add OWASP WTE's key and repo
sudo echo "deb http://appseclive.org/apt/14.04 trusty main" > /etc/apt/sources.list.d/owasp-wte.list
wget -q -O - http://appseclive.org/apt/owasp-wte.gpg.key | apt-key add -

# Install WebGoat and set permissions allowing hacker user access
apt-get update && apt-get -y install owasp-wte-webgoat
chown -R root:hacker /opt/owasp/webgoat

#
# Install Gauntlt
#

# Install Ruby latest stable with rvm and use gem to install Gauntlt
su -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3' hacker
su -c 'curl -sSL https://get.rvm.io | bash -s stable --ruby' hacker
su -c 'source /home/hacker/.rvm/scripts/rvm && cd /home/hacker && gem install gauntlt' hacker

# Install complete
echo ""
echo " Install of WebGoat and Gauntlt complete"
echo ""
