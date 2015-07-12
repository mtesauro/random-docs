# Install ThreadFix on CentOS/RHEL 6.x

## Install Java 8

### Get the latest version of Java's 

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

## Install Tomcat 8

### Get the latest version of Tomcat 8

Check the [official Tomcat download site](https://tomcat.apache.org/download-80.cgi) for the most recent version.

Download the binary .tar.gz version and grab the PGP and sha1 files as well.

```
# wget http://apache.osuosl.org/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz
# wget https://www.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz.asc
# wget https://www.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz.sha1
```

### Check the download's SHA1 sum and PGP signature.

```
# sha1sum apache-tomcat-8.0.24.tar.gz >> apache-tomcat-8.0.24.tar.gz.sha1
# vi apache-tomcat-8.0.24.tar.gz.sha1
  (or less, nano or the your editor of choice - 
   just make sure the sums match)
# gpg --verify apache-tomcat-8.0.24.tar.gz.asc 
gpg: Signature made Wed 01 Jul 2015 03:23:09 PM CDT using RSA key ID 2F6059E7
gpg: Can't check signature: No public key
```

This is expected if you've never checked the signature before.  You'll need to fetch it and add it to your gpg keychain.  If you don't have the signature, get it the first time.  The vital item is the **RSA key ID 2F6059E7** from the output above.  Use that like:

```
# gpg --keyserver hkp://keys.gnupg.net --recv-keys 2F6059E7
gpg: requesting key 2F6059E7 from hkp server keys.gnupg.net
gpg: /root/.gnupg/trustdb.gpg: trustdb created
gpg: key 2F6059E7: public key "Mark E D Thomas <markt@apache.org>" imported
gpg: no ultimately trusted keys found
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
```

Now that you actually have the key, do verify again:

```
# gpg --verify apache-tomcat-8.0.24.tar.gz.asc 
gpg: Signature made Wed 01 Jul 2015 03:23:09 PM CDT using RSA key ID 2F6059E7
gpg: Good signature from "Mark E D Thomas <markt@apache.org>"
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: A9C5 DF4D 22E9 9998 D987  5A51 10C0 1C5A 2F60 59E7
```

The not trusted thing is OK unless you've been to a PGP/gpg key signing party with Mark E D Thomas.  If that's true, I assume you know what to do.  Move info on gpg signing at the kernel.org URL in the resources used section below.

### Extract and move Tomcat

Extract Tomcat from the tarball and move it to /opt.

```
# tar -xzvf apache-tomcat-8.0.24.tar.gz
  [bunch of text scroll removed]
# touch apache-tomcat-8.0.24/00-apache-tomcat-8.0.24
  (lets you easily determine installed version with a clean path)
# mv apache-tomcat-8.0.24 /opt/tomcat
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

If you're *lucky*, it will only be listening on IPv6 addresses like the above.  To fix that create a setenv.sh script in the /opt/tomcat/bin.  From the comments in catalina.sh, which is called by startup.sh:

> Do not set the variables in this script. Instead put them into a script
> setenv.sh in CATALINA_BASE/bin to keep your customizations separate.

Create setenv.sh with vi or your favorite editor including the following contents:

```
JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true "
```
Much better now:

```
# netstat -ptln
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      4481/sshd           
tcp        0      0 127.0.0.1:8005              0.0.0.0:*                   LISTEN      17808/java          
tcp        0      0 0.0.0.0:8009                0.0.0.0:*                   LISTEN      17808/java          
tcp        0      0 0.0.0.0:8080                0.0.0.0:*                   LISTEN      17808/java          
tcp        0      0 :::22                       :::*                        LISTEN      4481/sshd           
```

### Create an init.d 

### Harden Tomcat

### Install ThreadFix war file

Inject our own jdbc.properties file into the TF war file


#### Resources used:
+ http://tecadmin.net/install-java-8-on-centos-rhel-and-fedora/
* https://www.kernel.org/signature.html