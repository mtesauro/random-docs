# Install ThreadFix on CentOS/RHEL 6.x

## Install Java 8

### Get the latest version of Java 8 from Oracle 

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

Create user so Tomcat does not as root and use /opt/tomcat as its home directory.

```
# groupadd tomcat
# useradd -g tomcat -c "Apache Tomcat" -d /opt/tomcat tomcat
useradd: warning: the home directory already exists.
Not copying any file from skel directory into it.
# chown -R tomcat.tomcat /opt/tomcat/
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

Edit or replace the jdbc.properties file in the expanded .war file to point at your MySQL/MariaDB database.

```
# vi threadfix/WEB-INF/classes/jdbc.properties
  (example at the bottom of this doc)
```

Move the ThreadFix app over to Tomcat

```
# mv threadfix /opt/tomcat/webapps/
# chown -R tomcat.tomcat /opt/tomcat/webapps/threadfix/
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

### Harden Tomcat

Best suggestion is to front Tomcat with Nginx and use iptables to close all but 22, 80 and 443 inbound.  Then configure Nginx to forward 80 to 443. Tomcat only needs to answer to localhost requests from Nginx plus SSL and other configuration management is much easier with Nginx.

#### Helpful Resources
+ http://tecadmin.net/install-java-8-on-centos-rhel-and-fedora/
* https://www.kernel.org/signature.html
* http://tecadmin.net/steps-to-install-tomcat-server-on-centos-rhel/
* http://www.davidghedini.com/pg/entry/install_tomcat_7_on_centos
* https://gist.github.com/timothyhutz/207c9b8f8b4ff3f79abd
* http://darkmind2007.blogspot.com/2010/06/linux-add-custom-script-to-chkconfig.html
* https://gist.github.com/miglen/5590986
* https://www.owasp.org/index.php/Securing_tomcat
* http://tomcat.apache.org/tomcat-3.2-doc/uguide/tomcat_ug.html
* https://tomcat.apache.org/tomcat-7.0-doc/logging.html
* https://www.unidata.ucar.edu/software/thredds/v4.3/tds/tds4.3/reference/JavaOptsSummary.html
* http://blog.sokolenko.me/2014/11/javavm-options-production.html

### Config files

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