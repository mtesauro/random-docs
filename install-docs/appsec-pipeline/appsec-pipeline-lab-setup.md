# AppSec Pipeline - Lab setup on Ubuntu 14.04 / OWASP WTE 14-04

## Install Prerequisites

### Install Nginx

Install Nginx to front both ThreadFix and Bag of Holding

```
$ sudo apt-get install nginx
```

### Install MariaDB

Install MariaDB to store data from ThreadFix and Bag of Holding

``` 
$ sudo apt-get install mariadb-server
```

Set root password per debconf

### Install Tomcat and Threadfix

ThreadFix needs Java 8 which can be installed by using a PPA

```
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer
$ sudo apt-get install oracle-java8-set-default
$ java -version
java version "1.8.0_60"
Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
Java HotSpot(TM) Client VM (build 25.60-b23, mixed mode)
```

Install Tomcat7 then ThreadFix from the current .deb version

```
$ sudo apt-get install tomcat7
$ sudo dpkg -i /path/to/threadfix/deb/file/ThreadFix-2.2.3-Community.deb
```

Create a scratch folder for ThreadFix

```
$ sudo mkdir -p /var/lib/threadfix/tfscratch
$ sudo chown -R tomcat7:tomcat7 /var/lib/threadfix
```

Edit /etc/default/tomcat7 and make the following two changes

1 - After the line:

```
#JAVA_HOME=/usr/lib/jvm/openjdk-6-jdk
```

add the following:

```
JAVA_HOME=/usr/lib/jvm/java-8-oracle/
```

2 - Update the JAVA_OPTS by commenting out the line of /etc/default/tomcat7 that reads:

```
JAVA_OPTS="-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC"
```

And add the following lines bellow the line you just commented out:

```
JAVA_OPTS="${JAVA_OPTS} -Dthreadfix.scratchFolder=/var/lib/threadfix/tfscratch "
JAVA_OPTS="${JAVA_OPTS} -Xms256m -Xmx512m "
JAVA_OPTS="${JAVA_OPTS} -Djava.awt.headless=true -XX:+UseConcMarkSweepGC -server "
JAVA_OPTS="${JAVA_OPTS} -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true "
```

Restart Tomcat

```
$ sudo service tomcat7 restart
```

Check that Tomcat is listening on IPv4 and its serving the application.  Correctly listening on IPv4 looks like:

```
# netstat -ptln | grep java
tcp        0      0 127.0.0.1:8005          0.0.0.0:*               LISTEN      20561/java      
tcp        0      0 0.0.0.0:35686           0.0.0.0:*               LISTEN      20561/java      
tcp        0      0 0.0.0.0:1099            0.0.0.0:*               LISTEN      20561/java      
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      20561/java 
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

Run the following commands to switch from HSQL to MySQL/MariaDB:

```
$ cd /usr/share/threadfix/threadfix/WEB-INF/classes
$ sudo cp jdbc.properties jdbc.properties.hsql
$ sudo cp jdbc.properties.mysql jdbc.properties
```

Edit jdbc.properties with the MariaDB information:

```
$ cd /usr/share/threadfix/threadfix/WEB-INF/classes
$ sudo vi jdbc.properties
  (example at the bottom of this doc)
```

### Create the ThreadFix databases

Change the jdbc file to set the mode to create by editing the file

```
$ cd /usr/share/threadfix/threadfix/WEB-INF/classes
$ sudo vi jdbc.properties
```

AND change the line that reads

```
hibernate.hbm2ddl.auto=update
```

to read:

```
hibernate.hbm2ddl.auto=create
```

Restart Tomcat to create the ThreadFix databases

```
$ sudo service tomcat7 restart
```

Wait a couple of minutes for ThreadFix to create and populate various databases.  You can tail the log file to watch for the creations to finish like:

```
sudo tail -f /var/log/tomcat7/threadfix-app-log.log
```

Until you see messages like the below repeating regularly.

```
2015-09-05 15:42:32,431 [DefaultQuartzScheduler_QuartzSchedulerThread] DEBUG org.quartz.core.QuartzSchedulerThread (QuartzSchedulerThread.java:276) - batch acquisition of 0 triggers
```

### Set ThreadFix back to update mode

Change the jdbc file to set the mode to create by editing the file

```
$ cd /usr/share/threadfix/threadfix/WEB-INF/classes
$ sudo vi jdbc.properties
```

AND change the line that reads

```
hibernate.hbm2ddl.auto=create
```

to read:

```
hibernate.hbm2ddl.auto=update
```

Restart Tomcat to run ThreadFix in its normal operation mode

```
$ sudo service tomcat7 restart
```

Open a browser and navigate to http://localhost:8080/threadfix/ and you should see the ThreadFix login page.  Default login is user / password.  Log in and verify ThreadFix is working.  Don't make any changes at this point.Do a final login check and change the default user to a different username and password of at least 10 characters e.g. threadfix-root & eishaiPhu9.  Create additional users as needed.

## Install Bag of Holding

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

## Configure Nginx to serve ThreadFix and BOH

# Create an SSL certificate to use with Nginx

```
# cd /etc/ssl/private/
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout pipeline.pvt.key -out pipeline.pvt.crt
```

I use the following for the openssl prompts, feel free to be creative for your own setups:

US, Texas, Austin, AppSec Pipeline, AppSec, pipeline.pvt, no-reply@owasp.org

Update Nginx config to 'front' 

```
# cd /etc/nginx/sites-available
# mv default cya-default
# vi default
  (example at the bottom of this doc)
```

Create a SSL cert for Nginx to use

```
# cd /etc/ssl/private
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout pipeline.pvt.key -out pipeline.pvt.crt
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

Switch out Nginx's default index page

```
# cd /usr/share/nginx/html
# vi index.html
  (example at the bottom of this doc)
```

Block direct access to Threadfix and BOH - OPTIONAL for labs

```
# ufw enable
Firewall is active and enabled on system startup
# ufw allow ssh
# ufw allow https
# ufw delete 4
Deleting:
 allow 443
Proceed with operation (y|n)? y
Rule deleted (v6)
# ufw delete 3
Deleting:
 allow 22
Proceed with operation (y|n)? y
Rule deleted (v6)
```

## Config files

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
