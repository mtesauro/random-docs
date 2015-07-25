# Create a new .deb/.rpm for a Bag of Holding Release

## Prerequisites


1. Bag of Holding environment setup - Python 3, Django, Supervisord, etc.
1. Bag of Holding already installed via .deb/.rpm
1. FPM installed and working on a host to build the new BOH packages

## Get the latest source

### First time setup

Setup, if needed, a project directory and clone the repo if you've never packaged on this computer before.

```
$ mkdir ~/projects/boh-fpm
$ cd ~/projects/boh-fpm
$ git clone https://github.com/PearsonEducation/bag-of-holding.git
Initialized empty Git repository in /home/mtesauro/projects/boh-fpm/bag-of-holding/.git/
remote: Counting objects: 10633, done.
remote: Total 10633 (delta 0), reused 0 (delta 0), pack-reused 10632
Receiving objects: 100% (10633/10633), 12.87 MiB | 1.57 MiB/s, done.
Resolving deltas: 100% (3898/3898), done.
```
Create a few more items needed for packaging BOH

```
$ mkdir env
$ vi boh-excludes
  (contents at the bottom of this doc)
```

Create some files we'll use on an ongoing basis in the fpm-files directory.

* prod.py - settings file with production values
* prod-secret-key - used in prod.py for Django's SECRET_KEY setting

Create some files we'll use on an ongoing basis in the root of the project directory.

* build-deb - script to consistently call FPM to build debs
* build-rpm - script to consistently call FPM to build rpms
* boh-postinsts - script to run after BOH package is installed
* boh-preinst - script to run before BOH package is installed

```
$ mkdir fpm-files
$ vi prod.py
  (contents at the bottom of this doc)
$ cat /dev/urandom| tr -dc 'a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?=' | fold -w 50| head -n 1 | xargs echo -n >> fpm-files/prod-secret-key
$ cd ../
  (important these live in the root of your project directory)
$ vi build-deb
  (contents at the bottom of this doc)
$ vi build-rpm
  (contents at the bottom of this doc)
$ chmod u+x build-deb build-rpm
```

### Update to the latest source from the repo

If there's an existing repo checkout on this computer, pull the latest version from the repo.

```
$ cd bag-of-holding
$ git pull
remote: Counting objects: 45, done.
remote: Compressing objects: 100% (31/31), done.
remote: Total 45 (delta 15), reused 42 (delta 12), pack-reused 0
Unpacking objects: 100% (45/45), done.
From https://github.com/PearsonEducation/bag-of-holding
 * [new branch]      gh-pages   -> origin/gh-pages
   8e1fd82..7b1cb42  master     -> origin/master
```

If you're using a specific release, check it out with git

```
$ git checkout v0.0.4
Branch v0.0.4 set up to track remote branch v0.0.4 from origin.
Switched to a new branch 'v0.0.4'
$ 
```

## Package with FPM

### Setup the working directory for FPM

Create the working directory

```
$ pwd
/home/mtesauro/projects/boh-fpm
$ rsync -Pav --exclude-from=boh-excludes --delete bag-of-holding env/
  [bunch of output removed]
sent 2329615 bytes  received 4631 bytes  4668492.00 bytes/sec
total size is 2312947  speedup is 0.99
```

### Gather info needed by FPM

Find out the version getting packaged.

```
$ head -n 1 bag-of-holding/project/boh/__init__.py 
__version__ = '1.0.3'
```

Copy the prod.py file to the settings directory

```
$ cp fpm-files/prod.py env/bag-of-holding/project/project/settings/
```

### Build the packages

There are scripts to automate the repetitive parts of calling FPM for these packages.  Calling them looks like

> $ ./build-deb [version number] [iteration number]

Version number is required while iteration number is optional and only needed if there's a bug in how BOH was packaged.  An example call to build *bag-of-holding_1.3.7-04_all.deb* would be:

> ./build-deb 1.3.7 04

To build *bag-of-holding-1.0.1-00.noarch.rpm* would be:

> ./build-rpm 1.0.1

So, build a deb and rpm packages

```
$ pwd
/home/mtesauro/projects/boh-fpm
$ ./build-deb 1.0.3
$ ./build-rpm 1.0.3
```

### Move the files over to your server

Move the .deb or .rpm over to the server - scp is probably the best method

```
$ scp bag-of-holding_1.0.3-00_all.deb user@prod.example.com:/home/user/
user@prod.example.com's password:
```

## Server install

Connect to the server and shutdown BOH before we do the upgrade.  +1 for data integrity.

```
# supervisorctl stop boh

```

### Setup the ThreadFix cron if you're using TF



### Config files

> {project directory}/boh-excludes

```
.git
.gitignore
gulpfile.js
bower.json
```

> {project directory}/fpm-files/prod.py

```
"""
This is the settings file that you use in production.
"""

from .base import *


# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '#CH-+ib|nbobLV(y2DDh6DdaEs)8mxYioN#INdVf*rQ?$lRpq('

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

# Database
# https://docs.djangoproject.com/en/1.8/ref/settings/#databases
# Change database to MySQL for production
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql', 
        'NAME': 'boh',
        'USER': 'boh-dba',
        'PASSWORD': 'ighiJegeeghaeZecheiR2Mei',
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

> build-deb

```
#!/bin/bash

# Set the version number
if [ -s $1 ]
then
    VERSION=XXX
else
    VERSION=$1
fi

# Set the iteration number
if [ -s $2 ]
then
    ITER=00
else
    ITER=$2
fi


fpm -t deb --name "bag-of-holding" --iteration $ITER --depends python3 --depends python3-pip --architecture all --maintainer "Matt Tesauro <mtesauro@gmail.com>" --description "Bag of Holding - Your AppSec program in a bag" --before-install ./boh-preinst --after-install ./boh-postinst --url "https://github.com/PearsonEducation/bag-of-holding" --license "Apache License, Version 2.0." --version $VERSION --vendor "Pearson AppSec Team" -s dir ./env=/opt/boh

```

> build-rpm

```
#!/bin/bash

# Set the version number
if [ -s $1 ]
then
    VERSION=XXX
else
    VERSION=$1
fi

# Set the iteration number
if [ -s $2 ]
then
    ITER=00
else
    ITER=$2
fi


fpm -t rpm --name "bag-of-holding" --iteration $ITER --depends scl-utils --depends python33 --architecture all --maintainer  "Matt Tesauro <mtesauro@gmail.com>" --description "Bag of Holding - Your AppSec program in a bag" --before-install ./boh-preinst --after-install ./boh-postinst --rpm-os linux --url "https://github.com/PearsonEducation/bag-of-holding" --license "Apache License, Version 2.0." --version $VERSION --vendor "Pearson AppSec Team" -s dir ./env=/opt/boh

```

> boh-postinst

```
#!/bin/sh

# Reserved for future additions/automation

```

> boh-preinst

```
#!/bin/sh

# Reserved for future additions/automation

```