# AppSec Pipeline - Lab setup on CentOS-6 / RHEL-6

**NOTE** CONSIDER THIS AN ALPHA QUALITY DOC CURRENTLY

## Install Prerequisites

### Install Nginx

Install Nginx to front both ThreadFix and Bag of Holding

```
# yum install epel-release
  [answer yes]
# yum install nginx
  [answer yes]
```

### Install MariaDB - FIXME

Add the official CentOS MariaDB repo to CentOS and install the repo key

``` 
# rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
# vi /etc/yum.repos.d/MariaDB.repo
```

And add the contents:

```
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
```

Install MariaDB to store data from ThreadFix and Bag of Holding

```
# yum install MariaDB-server MariaDB-client
  [answer yes]
```

Set root password for MariaDB

```
# mysql_secure_installation
  [follow the prompts to set the root password and secure your install]
```

## Install Tomcat and Threadfix on CentOS/RHEL 6.x

### Install the latest version of Java 8 from Oracle 

Find out what the current version is at [Oracle Java Download Page](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

Then use the following to download the latest Java 8 replacing ```{Java download}``` with the current version:

>wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "{Java download}"

For example, here's the call for getting Java 8 update 45:

> wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm"

Reference links for downloads:

[Java 8 update 45 RPM](http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm)

[Java 8 update 45 tarball](http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz)

### Install Java via the RPM

From the directory where you downloaded the RPM:

```
# rpm -ivh jdk-8u45-linux-x64.rpm 
```

### Setup needed environmental variables

```
# vi /etc/environment
```

and add the following:

```
# Setup for the Oracle Java RPM
export JAVA_HOME=/usr/java/jdk1.8.0_45
export JRE_HOME=/usr/java/jdk1.8.0_45/jre
```

### If you have an existing Java install

Check to see if there's more then one JDK:

```
# rpm -qa | grep jdk
java-1.7.0-openjdk-devel-1.7.0.85-2.6.1.3.el6_7.x86_64
jdk1.8.0_65-1.8.0_65-fcs.x86_64
java-1.7.0-openjdk-1.7.0.85-2.6.1.3.el6_7.x86_64
```

Use alternatives to setup the 1.8.x Java just installed

```
# alternatives --config java

There are 2 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
*+ 1           /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java
   2           /usr/java/jdk1.8.0_65/jre/bin/java

Enter to keep the current selection[+], or type selection number: 2
# alternatives --display java | grep points
 link currently points to /usr/java/jdk1.8.0_65/jre/bin/java
```

You're good to go, the older JDK is not the default

### Check your setup

```
# source /etc/environment 
# which java
/usr/bin/java
# java -version
java version "1.8.0_45"
Java(TM) SE Runtime Environment (build 1.8.0_45-b14)
Java HotSpot(TM) 64-Bit Server VM (build 25.45-b02, mixed mode)
# echo $JAVA_HOME
/usr/java/jdk1.8.0_45
# echo $JRE_HOME
/usr/java/jdk1.8.0_45/jre

``` 

## Install Tomcat 7

### Get the latest version of Tomcat 7

Check the [official Tomcat download site](https://tomcat.apache.org/download-70.cgi) for the most recent version.

Download the binary .tar.gz version and grab the PGP and sha1 files as well.

```
# wget http://mirror.cc.columbia.edu/pub/software/apache/tomcat/tomcat-7/v7.0.63/bin/apache-tomcat-7.0.63.tar.gz
# wget https://www.apache.org/dist/tomcat/tomcat-7/v7.0.63/bin/apache-tomcat-7.0.63.tar.gz.asc
# wget https://www.apache.org/dist/tomcat/tomcat-7/v7.0.63/bin/apache-tomcat-7.0.63.tar.gz.sha1
```

### Check the download's SHA1 sum and PGP signature.

```
# sha1sum apache-tomcat-7.0.63.tar.gz >> apache-tomcat-7.0.63.tar.gz.sha1
# vi apache-tomcat-7.0.63.tar.gz.sha1
  (or less, nano or the your editor of choice - 
   just make sure the sums match)
# gpg --verify apache-tomcat-7.0.63.tar.gz.asc 
gpg: Signature made Tue 30 Jun 2015 03:13:20 AM CDT using RSA key ID D63011C7
gpg: Can't check signature: No public key
```

This is expected if you've never checked the signature before.  You'll need to fetch it and add it to your gpg keychain.  If you don't have the signature, get it the first time.  The vital item is the **RSA key ID D63011C7** from the output above.  Use that like:

```
# gpg --keyserver hkp://keys.gnupg.net --recv-keys D63011C7
gpg: requesting key D63011C7 from hkp server keys.gnupg.net
gpg: key D63011C7: public key "Violeta Georgieva Georgieva (CODE SIGNING KEY) <violetagg@apache.org>" imported
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
```

If you  cannot access Apache's signing key via hkp://, its also available at [MIT's Keyserver](https://pgp.mit.edu/pks/lookup?op=get&search=0x208B0AB1D63011C7)

Now that you actually have the key, do verify again:

```
# gpg --verify apache-tomcat-7.0.63.tar.gz.asc 
gpg: Signature made Tue 30 Jun 2015 03:13:20 AM CDT using RSA key ID D63011C7
gpg: Good signature from "Violeta Georgieva Georgieva (CODE SIGNING KEY) <violetagg@apache.org>"
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 713D A88B E509 1153 5FE7  16F5 208B 0AB1 D630 11C7

```

The not trusted signature thing is OK unless you've been to a PGP/gpg key signing party with Mark E D Thomas.  If that's true, I assume you know what to do.  Move info on gpg signing at the kernel.org URL in the resources used section below.

### Extract and move Tomcat

Extract Tomcat from the tarball and move it to /opt.

```
# tar -xzvf apache-tomcat-7.0.63.tar.gz
  [bunch of text scroll removed]
# touch apache-tomcat-7.0.63/00-apache-tomcat-7.0.63
  (lets you easily determine installed version with a clean path)
# mv apache-tomcat-7.0.63 /opt/tomcat
```

### Do a test launch of Tomcat

Using the Tomcat provided .sh script, launch Tomcat and make sure it works as expected

```
# cd /opt/tomcat
# export CATALINA_HOME=/opt/tomcat
# ./bin/startup.sh
Using CATALINA_BASE:   /opt/tomcat
Using CATALINA_HOME:   /opt/tomcat
Using CATALINA_TMPDIR: /opt/tomcat/temp
Using JRE_HOME:        /usr/java/jdk1.8.0_45/jre
Using CLASSPATH:       /opt/tomcat/bin/bootstrap.jar:/opt/tomcat/bin/tomcat-juli.jar
Tomcat started.
```

Check to make sure its listening as it should.

```
# netstat -ptln
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      4481/sshd           
tcp        0      0 :::22                       :::*                        LISTEN      4481/sshd           
tcp        0      0 ::ffff:127.0.0.1:8005       :::*                        LISTEN      17743/java          
tcp        0      0 :::8009                     :::*                        LISTEN      17743/java          
tcp        0      0 :::8080                     :::*                        LISTEN      17743/java
```

If you're *lucky*, it will only be listening on IPv6 addresses like the above.  That's OK for now.  We address this in the init.d script we create in the next step, forcing Tomcat to listen only on the IPv4 address.

### Create an init.d script

First, create a scratch directory for ThreadFix to use

```
# mkdir /opt/tomcat/tfscratch
```

Create a script that will start and stop Tomcat during server restarts:

```
# cd /etc/init.d/
# vi tomcat
  (contents at the bottom of this doc)
# chmod 755 tomcat
```

Now add Tomcat to chkconfig so that is starts up on reboot.  Go ahead an make sure it works as expected.

```
# chkconfig --add tomcat
# chkconfig --list tomcat
tomcat   0:off  1:off  2:on  3:on  4:on  5:on  6:off
# service tomcat status
Tomcat is not running
# service tomcat start
Starting tomcat
 [a few lines removed]
Tomcat is running with pid: 19734
# service tomcat stop
Stoping Tomcat
 [a few lines removed]
waiting for processes to exit
#
```

### Create a user for Tomcat/ThreadFix to use

Create user so Tomcat does not run as root and use /opt/tomcat as its home directory.

```
# groupadd tomcat
# useradd -g tomcat -c "Apache Tomcat" -d /opt/tomcat tomcat
useradd: warning: the home directory already exists.
Not copying any file from skel directory into it.
# chown -R tomcat:tomcat /opt/tomcat/
```

### Setting up MySQL/MariaDB with ThreadFix

Create the database and user for ThreadFix making sure to support full UTF8 character set, replacing [threadfix user] and [threafix password] below with the appropriate values from the just edited jdbc.properties file.

```
$ mysql -u root -p
    [many lines removed for brevity]
MariaDB [(none)]> CREATE DATABASE threadfix CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
Query OK, 1 row affected (0.00 sec)

MariaDB [(none)]> CREATE USER '[threadfix user]'@'localhost' IDENTIFIED BY '[threadfix password]';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON threadfix.* TO '[threadfix user]'@'localhost' IDENTIFIED BY '[threadfix password]';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> quit
Bye
```

### Install ThreadFix war file

Move (e.g. scp) the ThreadFix WAR file over to the server and extract the WAR contents

```
# cd /root
# mkdir tf-temp
# mv /location/of/threadfix/war/threadfix.war /root/tf-temp
# cd /root/tf-temp
# unzip threadfix.war -d threadfix
```

**NOTE** May need to alter these to run initially to create the 

Edit or replace the jdbc.properties file in the expanded .war file to point at your MySQL/MariaDB database.

```
# vi threadfix/WEB-INF/classes/jdbc.properties
  (example at the bottom of this doc)
```

Move the ThreadFix app over to Tomcat

```
# mv threadfix /opt/tomcat/webapps/
# chown -R tomcat:tomcat /opt/tomcat/webapps/threadfix/
```

### Test that ThreadFix works

Startup Tomcat

```
# service tomcat start
```

And head to http://your-host-name.com:8080/threadfix

The default credentials are

* Username: user
* Password: password

**Change these and setup a ThreadFix admin account right after your first login or be owned.**



## Install Bag of Holding - FIXME FOR CENTOS-6 **********************************************************

### Setup the pre-requisites for BOH

BOH uses Python 3 + Virtualenv so install them

```
# apt-get install python3-pip
# pip3 install virtualenv
# apt-get install git
```

Create a home for BOH

```
# mkdir -p /opt/boh
# cd /opt/boh
# virtualenv env
Using base prefix '/usr'
New python executable in env/bin/python3
Also creating executable in env/bin/python
Installing setuptools, pip, wheel...done.
```

Get the BOH source and checkout the 0.0.4 branch

```
# cd /opt/boh/env
# git clone https://github.com/PearsonEducation/bag-of-holding.git
    [many lines removed for brevity]
# cd bag-of-holding
# git checkout v0.0.4
Branch v0.0.4 set up to track remote branch v0.0.4 from origin.
Switched to a new branch 'v0.0.4'
root@pipeline:/opt/boh/bag-of-holding# git branch
  master
* v0.0.4
```

# Create the prod.py settings file

```
# cd /opt/boh/bag-of-holding/project/project/settings/
# vi prod.py
  (example at the bottom of this doc)
```

Make sure to add the credentials for the BOH db user and its password.  The user will be added to MySQL/MariaDB shortly.

Also, you can use something like the below to generate a long random value for the SECRET_KEY

```
# cat /dev/urandom| tr -dc 'a-zA-Z0-9' | fold -w 50| head -n 1 | xargs echo 
0PPFbhEILsJNVTKmzbw22Jx2Ed2oBh2Yu3N8SkyEoRkwEVIx8K
```

### Setup BOH database

Create the database and user for BOH making sure to support full UTF8 character set, replacing [boh user] and [boh password] below with the appropriate values from the just created prod.py file.

```
$ mysql -u root -p
    [many lines removed for brevity]
MariaDB [(none)]> CREATE DATABASE boh CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
Query OK, 1 row affected (0.00 sec)

MariaDB [(none)]> CREATE USER '[boh user]'@'localhost' IDENTIFIED BY '[boh password]';
Query OK, 0 rows affected (0.04 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON boh.* TO '[boh user]'@'localhost' IDENTIFIED BY '[boh password]';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> quit
Bye
```

### Complete the BOH install

Install the required dev libraries to build the Python modules

```
# apt-get install libmariadbclient-dev libssl-dev
```

Install required Python modules

```
# cd /opt/boh
# source ./env/bin/activate
(env)# python --version
Python 3.4.0
(env)# cd env/bag-of-holding
(env)# pip install -r requirements/production.txt 
(env)# pip install -r requirements/local.txt 
```

Create a directory for the static files

```
(env)# mkdir /opt/boh/env/static
```

Complete the Django setup 

```
# cd /opt/boh/env/bag-of-holding/project
(env)# export DJANGO_SETTINGS_MODULE=project.settings.prod; python manage.py makemigrations
(env)# export DJANGO_SETTINGS_MODULE=project.settings.prod; python manage.py migrate
(env)# export DJANGO_SETTINGS_MODULE=project.settings.prod; python manage.py collectstatic --noinput
(env)# export DJANGO_SETTINGS_MODULE=project.settings.prod; python manage.py createsuperuser
Username (leave blank to use 'root'): boh-superuser
Email address: no-reply@owasp.org
Password: 
Password (again): 
Superuser created successfully.
```

Note: makemigrations & createsuperuser are only required for first-time installs

Check to make sure BOH is working by starting up a test instance

```
# cd /opt/boh/env/bag-of-holding/project
# export DJANGO_SETTINGS_MODULE=project.settings.prod; python manage.py runserver
```

And try to login at http://127.0.0.1:8000/boh/ 

Note:  The CSS and other static content will 404 since we plan on using Nginx to server that content rather then Django which means BOH will look really ugly/plain at this stage.  We just want to prove it workd and the superuser can login.  

After successfully logging in, hit CTL-C in the terminal to stop the temporary BOH server.

### Setup BOH to start on reboot

Install gunicorn and setproctitle

```
# cd /opt/boh/env
# source bin/activate
(env)# pip install gunicorn
    [lines removed for brevity]
(env)# pip install setproctitle
```

In a different terminal, create a boh user and group and a startup script for BOH

```
# useradd boh
# vi /opt/boh/env/bin/boh-startup
  (example at the bottom of this doc)
# chmod 775 /opt/boh/env/bin/boh-startup
```

Install supervisor to startup BOH on reboot

```
#  apt-get install supervisor
# vi /etc/supervisor/conf.d/boh.conf
  (example at the bottom of this doc)
# mkdir /opt/boh/env/logs
# touch /opt/boh/env/logs/boh-supervisor.log
# chown -R boh:boh /opt/boh
```

Test supervisor to ensure its starting up BOH

```
# supervisorctl reread
boh: available
# supervisorctl update
boh: added process group
# supervisorctl status boh
boh                 RUNNING    pid 6631, uptime 0:00:12
```

And try to login at http://127.0.0.1:8000/boh/ 

Note:  Some of the CSS and other static content will 404 since we plan on using Nginx to server that content rather then Django

The following commands can be used to control BOH's operation and work as expected

```
# supervisorctl stop boh
boh: stopped
# supervisorctl start boh
boh: started
# supervisorctl restart boh
boh: stopped
boh: started
# ps aux | grep boh
boh      11524  0.1  0.7  71680 16212 ?        S    15:49   0:00 gunicorn: master [boh]
boh      11533  0.1  1.3  97872 27032 ?        S    15:49   0:00 gunicorn: worker [boh]
boh      11534  0.1  1.3  97876 27036 ?        S    15:49   0:00 gunicorn: worker [boh]
boh      11535  0.1  1.3  97884 27152 ?        S    15:49   0:00 gunicorn: worker [boh]
```

********************************************************** FIXME FOR CENTOS-6 ENDS **********************************************************

## Configure Nginx to serve ThreadFix and BOH

# Create an SSL certificate to use with Nginx

```
# mkdir /etc/ssl/private
# cd /etc/ssl/private/
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout pipeline.pvt.key -out pipeline.pvt.crt
```

I use the following for the openssl prompts, feel free to be creative for your own setups:

US, Texas, Austin, AppSec Pipeline, AppSec, pipeline.pvt, no-reply@owasp.org

Update Nginx config to 'front' 

```
# cd /etc/nginx/conf.d
# mkdir cya
# mv *.conf cya
# vi default.conf
  (example at the bottom of this doc)
```

Setup host file to point pipeline.pvt to 127.0.0.1 by making sure there's a line like the below in /etc/hosts

```
127.0.0.1       localhost pipeline.pvt
```

Restart Nginx and test for access to ThreadFix and BOH

```
# service nginx restart
```

Browse to https://pipeline.pvt/threadfix and https://pipeline.pvt/boh to verify that both apps are being proxied as desired.

If you get odd errors that look like the below:

```
2016/03/26 04:18:40 [crit] 23423#0: *3 connect() to 10.25.80.21:8080 failed (13: Permission denied) while connecting to upstream, client: 10.25.231.18, server: 10.25.80.21, request: "GET /threadfix HTTP/1.1", upstream: "http://10.25.80.21:8080/threadfix", host: "10.25.80.21"
```

SELinux is keeping the reverse proxy from working.  To check, run:

```
# cat /var/log/audit/audit.log | grep nginx | grep denied
type=AVC msg=audit(1458982468.262:2980): avc:  denied  { name_connect } for  pid=23276 comm="nginx" dest=8080 scontext=unconfined_u:system_r:httpd_t:s0 tcontext=system_u:object_r:http_cache_port_t:s0 tclass=tcp_socket
  [many lines removed]
```

If you have results like the above, allow the reverse proxy by running:

```
# mkdir /root/selinux-adjustments
# cd /root/selinux-adjustments
# yum install policycoreutils-python
# cat /var/log/audit/audit.log | grep nginx | grep denied | audit2allow -M mynginx
# semodule -i mynginx.pp
```

Switch out Nginx's default index page

```
# cd /usr/share/nginx/html
# vi index.html
  (example at the bottom of this doc)
```

Block direct access to Threadfix and BOH - OPTIONAL for labs

```
# yum install dbus dbus-python system-config-firewall-tui
# service messagebus start
# system-config-firewall-tui
   [follow the prompts to allow ssh https & http]
```

## Config files

> /etc/environment

```
# Setup for the Oracle Java RPM
export JAVA_HOME=/usr/java/jdk1.8.0_45
export JRE_HOME=/usr/java/jdk1.8.0_45/jre
```

> /etc/init.d/tomcat

```
#!/bin/bash
# chkconfig: 2345 95 20
# description: Tomcat installation used to run ThreadFix
# processname: threadfix
#
# Tomcat 8 start/stop/status init.d script
# Initially forked from: https://gist.github.com/valotas/1000094
# @author: Miglen Evlogiev <bash@miglen.com>
#
# Updated and modified for use with ThreadFix by Matt Tesauro <mtesauro@gmail.com> based on Gist at
# https://gist.github.com/timothyhutz/207c9b8f8b4ff3f79abd
#

# JAVA_HOME and PATH already set in /etc/environment
source /etc/environment

# Set CATALINA_HOME - where Tomcat has been installed
CATALINA_HOME=/opt/tomcat

#CATALINA_BASE is the location of several key directories to run ThreadFix and hold the WAR file
export CATALINA_BASE=/opt/tomcat

# Force Java to prefer/use the IPv4 address over the default IPv6 preference.
# Comment out the line below to have Tomcat listen only on the IPv6 address, assuming IPv6 is configured
# I'd recomment fronting Tomcat with Nginx or similar to allow easier SSL, sharing host with other apps, etc.
export JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true "
# Commennt out line above and uncomment line below to run with verbose debug logging for log4j
#export JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Dlog4j.debug "

# Set the scracth directory for ThreadFix to use
export JAVA_OPTS="$JAVA_OPTS -Dthreadfix.scratchFolder=/opt/tomcat/tfscratch "

# Set the memory useage for ThreadFix
export JAVA_OPTS="$JAVA_OPTS -Xms256m -Xmx2048m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m "
# -Xms{##}m sets the initial amount of memory allocated to the JVM heap
# -Xmx{##}m sets the maximum amount of memory that can be allocated to the JVM heap
# For an server with lots of RAM, -Xms4096m -Xmx8192m is a good place to start
# Next two require Java 8, if Java 7, replace with -XX:PermSize=256m -XX:MaxPermSize=256m
# -XX:MetaspaceSize=256m & -XX:MaxMetaspaceSize=256m - By default Metaspace in Java VM 8 is not limited, so
#   so setting these limits them for stability so they don't grow until DOS

# Other Java Optimizations
export JAVA_OPTS="$JAVA_OPTS -Djava.awt.headless=true -XX:+UseConcMarkSweepGC -server "
# -Djava.awt.headless=true sets the value of the java.awt.headless system property to true. Setting this system
#   property to true prevent graphics rendering code from assuming that a graphics console exists.
# -XX:+UseConcMarkSweeGC is one of the available collectors for Garbage collection and good for web apps
# -server instructs the launcher to use the Java HotSpot Server VM designed for long running Java processes

# Set the user Tomcat will run as
export TOMCAT_USER=tomcat

#TOMCAT_USAGE is the message if this script is called without any options
TOMCAT_USAGE="Usage: $0 {\e[00;32mstart\e[00m|\e[00;31mstop\e[00m|\e[00;31mkill\e[00m|\e[00;32mstatus\e[00m|\e[00;31mrestart\e[00m}"

#SHUTDOWN_WAIT is wait time in seconds for java proccess to stop
SHUTDOWN_WAIT=20

tomcat_pid() {
        echo `ps -fe | grep $CATALINA_BASE | grep -v grep | tr -s " "|cut -d" " -f2`
}

start() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mTomcat is already running (pid: $pid)\e[00m"
  else
    # Start tomcat
    echo -e "\e[00;32mStarting tomcat\e[00m"

    if [ `user_exists $TOMCAT_USER` = "1" ]
    then
      sh $CATALINA_HOME/bin/startup.sh
      # Dies when using HSQL as tomcat user - not sure why
      #/bin/su $TOMCAT_USER -c $CATALINA_HOME/bin/startup.sh
    else
      sh $CATALINA_HOME/bin/startup.sh
    fi
    status
  fi
  return 0
}

status(){
          pid=$(tomcat_pid)
          if [ -n "$pid" ]; then echo -e "\e[00;32mTomcat is running with pid: $pid\e[00m"
          else echo -e "\e[00;31mTomcat is not running\e[00m"
          fi
}

terminate() {
        echo -e "\e[00;31mTerminating Tomcat\e[00m"
        kill -9 $(tomcat_pid)
}

stop() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mStoping Tomcat\e[00m"
    #/bin/su -p -s /bin/sh $TOMCAT_USER
        sh $CATALINA_HOME/bin/shutdown.sh

    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
      echo -n -e "\n\e[00;31mwaiting for processes to exit\e[00m";
      sleep 1
      let count=$count+1;
    done

    if [ $count -gt $kwait ]; then
      echo -n -e "\n\e[00;31mkilling processes didn't stop after $SHUTDOWN_WAIT seconds\e[00m"
      terminate
    fi
  else
    echo -e "\e[00;31mTomcat is not running\e[00m"
  fi

  # Gratuitous echo to get the terminal back lined up
  echo ""

  return 0
}

user_exists(){
        if id -u $1 >/dev/null 2>&1; then
        echo "1"
        else
                echo "0"
        fi
}

case $1 in
        start)
          start
        ;;
        stop)
          stop
        ;;
        restart)
          stop
          start
        ;;
        status)
                status
        ;;
        kill)
                terminate
        ;;
        *)
                echo -e $TOMCAT_USAGE
        ;;
esac
exit 0

```
> threadfix/WEB-INF/classes/jdbc.properties

```
# database settings, this can be the central location for different DB settings
# that are referenced in /src/main/resources/applicationContext-hibernate.xml.

#MYSQL
jdbc.driverClassName=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://10.10.10.10:3306/threadfix?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&jdbcCompliantTruncation=false
jdbc.username=threadfix-user
jdbc.password=baiphixeiNgiejah8ieciaweet
hibernate.dialect=org.hibernate.dialect.MySQL5Dialect
hibernate.hbm2ddl.auto=update

hibernate.show_sql=false

```


============================ CHECK ME ==================================
> /usr/share/threadfix/threadfix/WEB-INF/classes/jdbc.properties

```
# database settings, this can be the central location for different DB settings
# that are referenced in /src/main/resources/applicationContext-hibernate.xml.

#MYSQL
jdbc.driverClassName=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/threadfix?autoReconnect=true&createDatabaseIfNotExist=true&useUnicode=true&characterEncoding=UTF-8&jdbcCompliantTruncation=false
jdbc.username=tf-user
jdbc.password=tf-pass
hibernate.dialect=org.hibernate.dialect.MySQL5Dialect
hibernate.hbm2ddl.auto=update

hibernate.show_sql=false
hibernate.format_sql=true
```

> /opt/boh/env/bag-of-holding/project/project/settings/prod.py

```
"""
This is the settings file that you use in production.
"""

from .base import *


# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'Removed-for-some-reason'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False
#DEBUG = True

ALLOWED_HOSTS = [ '*', ]

# Database
# https://docs.djangoproject.com/en/1.8/ref/settings/#databases
# Change database to MySQL for production
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'boh',
        'USER': '[boh user]',
        'PASSWORD': '[boh password]',
        'HOST': 'localhost',   # Or an IP Address that your DB is hosted on
        'PORT': '3306',
    }
}

# Email
# https://docs.djangoproject.com/en/1.8/topics/email/#smtp-backend
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Shift BOH into a subdirectory on the server
URL_PREFIX = 'boh/'

LOGIN_URL = os.path.join('/', URL_PREFIX, 'accounts/login')
LOGIN_REDIRECT_URL = os.path.join('/', URL_PREFIX)

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.8/howto/static-files/
#STATIC_ROOT = os.path.join(BASE_DIR, os.pardir, os.pardir, 'static')
STATIC_ROOT = '/opt/boh/env/static/'
STATIC_URL = os.path.join('/', URL_PREFIX, 'static/')

#MEDIA_ROOT = os.path.join(BASE_DIR, os.pardir, os.pardir, 'media')
MEDIA_ROOT = os.path.join(BASE_DIR, os.pardir, 'media')
MEDIA_URL = os.path.join('/', URL_PREFIX, 'media/')
```

> /opt/boh/env/bin/boh-startup

```
#!/bin/bash

NAME="bag-of-holding"                         # Name of the app
DJANGODIR=/opt/boh/env/bag-of-holding/project # Django project dir
#SOCKFILE=/opt/boh/env/run/gunicorn.sock      # use unix sockets
USER=boh                                      # run as this user
GROUP=boh                                     # the group to run as
NUM_WORKERS=3                                 # how many workers 
                                              # usually # of CPU + 1
DJANGO_SETTINGS_MODULE=project.settings.prod  # which settings file 
                                              # should Django use
DJANGO_WSGI_MODULE=project.wsgi               # WSGI module name
GUNICORN_LOG_LEVEL=debug                      # Set log level
             # possible values: debug, info, warning, error, critical

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
source ../../bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
#RUNDIR=$(dirname $SOCKFILE)
#test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec ../../bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
#  --bind=unix:$SOCKFILE \
  --bind 127.0.0.1:8001
  --log-level=$GUNICORN_LOG_LEVEL \
  --log-file=-

# more info: http://docs.gunicorn.org/en/latest/deploy.html
```

> /etc/supervisor/conf.d/boh.conf

```
[program:boh]
command = /opt/boh/env/bin/boh-startup                 ; Command to start app
user = boh                                             ; User to run as
stdout_logfile = /opt/boh/env/logs/boh-supervisor.log  ; Where to write log messages
redirect_stderr = true                                 ; Save stderr in the same log
environment=LANG=en_US.UTF-8,LC_ALL=en_US.UTF-8        ; Set UTF-8 as default encoding

; more info at http://supervisord.org/configuration.html#program-x-section-settings
```


> /etc/nginx/sites-available/default

```
upstream boh_app_server {
  # fail_timeout=0 means we always retry an upstream even if it failed
  # to return a good HTTP response (in case the Unicorn master nukes a
  # single worker for timing out).
 
  server unix:/opt/boh/env/run/gunicorn.sock fail_timeout=0;
}


server {
    listen 80;

    # Increase max upload for Threadfix
    client_max_body_size 500M;

    # Redirect http to https
    return 301 https://$host$request_uri;

    # Uncomment the below if you want http inbound to talk to SSL for ThreadFix
    # Really, the only time you should be doing this is if you want to see
    # traffic to ThreadFix to debug something like REST API calls or the like
    # OTHERWISE DO NOT UNCOMMENT THE BELOW
    #location / {
    #
    #  proxy_set_header        Host $host;
    #  proxy_set_header        X-Real-IP $remote_addr;
    #  proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    #  proxy_set_header        X-Forwarded-Proto $scheme;
    #
    #  # Fix the “It appears that your reverse proxy set up is broken" error.
    #  proxy_pass          https://localhost:8443;
    #  proxy_read_timeout  90;
    #
    #  proxy_redirect      https://localhost:8443 http://127.0.0.1;
    #}

}

server {

    listen 443;
    server_name pipeline.pvt;

    # Increase max upload for ThreadFix
    client_max_body_size 500M;

    ssl_certificate           /etc/ssl/private/pipeline.pvt.crt;
    ssl_certificate_key       /etc/ssl/private/pipeline.pvt.key;

    ssl on;
    ssl_session_cache  builtin:1000  shared:SSL:10m;
    ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
    ssl_prefer_server_ciphers on;

    access_log            /var/log/nginx/pipeline.access.log;

    #MAT# Configs for phpMyAdmin
    index index.php index.html index.htm;
    
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
    
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location /boh/static/ {
      alias   /opt/boh/env/static/;
    }
    
    location /media/ {
      alias   /opt/boh/env/bag-of-holding/appsec/media/;
    }

    location /boh {
      # an HTTP header important enough to have its own Wikipedia entry:
      #   http://en.wikipedia.org/wiki/X-Forwarded-For
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      
      # enable this if and only if you use HTTPS, this helps to 
      # set the proper protocol for doing redirects:
      proxy_set_header X-Forwarded-Proto $scheme;
      
      # pass the Host: header from the client right along so redirects
      # can be set properly within the Rack application
      proxy_set_header Host $host;
      
      # we don't want nginx trying to do something clever with
      # redirects, we set the Host: header above already.
      proxy_redirect off;
      
      # Fix the “It appears that your reverse proxy set up is broken" error.
      proxy_pass          http://127.0.0.1:8000;
      proxy_read_timeout  90;
      
      proxy_redirect      http://127.0.0.1:8000 https://localhost/boh;
      
    }

    # Front ThreadFix 
    location /threadfix {

      proxy_set_header        Host $host;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;

      # Fix the “It appears that your reverse proxy set up is broken" error.
      proxy_pass          http://localhost:8080;
      proxy_read_timeout  90;

      proxy_redirect      http://localhost:8080 https://localhost/threadfix;
    }
}
```

> /usr/share/nginx/html/index.html

```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to AppSec Pipeline!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to the AppSec Pipeline training environment!</h1>
<p>If you see this page, the nginx web server was successfully installed and
working. To navigate to the various AppSec Pipeline parts, use the links below.</p>

<p>The Bag of Holding application is available
<a href="https://pipeline.pvt/boh">here</a>.<br/>
The ThreadFix application is available
<a href="https://pipeline.pvt/threadfix/login.jsp">here</a>.<br/><br/>
For more information on the OWASP AppSec Pipeline project, visit the
<a href="https://www.owasp.org/index.php/OWASP_AppSec_Pipeline">project page</a>.</p>


<p><em>I hope you enjoy exploring the AppSec Pipeline </em></p>
</body>
</html>
```

References:

* https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-centos-6-with-yum
* 
