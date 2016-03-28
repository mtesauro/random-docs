To install and get the beta site working locally, copy the beta-toolbox 
to a convenient location on your host.  If you are not using 64-bit Linux, 
then you'll need to replace the caddy executable in the beta-toolbox
directory with one for your OS.  You can get caddy at 
https://caddyserver.com/download - make sure you select the git feature 
so its added to the binary you download.

Once you have a working caddy executable, simply go to the beta-toolbox 
directory in a terminal and run:

```
$ caddy
```

and the site will be available at http://localhost:8888/

Enjoy!
