### gdrive sync

A collection of scripts to mount Google Drive on Linux and keep it sync'ed with a local directory. These were written to keep a directory of stuff available on any Linux box I worked on. This was written with .deb systems in mind and is being used by me on Xubuntu 16.04.

The collection consists of:

* gdrive-mount - script to mount Google Drive and start sync'ing it
* gdrive-vars - variables used when mounting and unmounting Google Drive
* sync-gdrive - auto-magical script using inotifywait to keep you local directory bi-directionally syncronized with Google Drive
* unmount-gdrive - script to stop auto-magical sync'ing and unmount Google Drive

Limitations: 

* Google Drive doesn't like exec permissions so any file syncronized with these scripts will loose there exec permissions and be set to 664 aka '-rw-rw-r--'
* Occasionally, the syncronization will be slower then the next file event. However, things will catch up if one of the following occurs:
* * the very next file event will catch things up by causing a sync 
* * you can make a insignificant file change to trigger sync'ing 
* * running umnount-gdrive will cause a final bi-directional syncronization to occur.
* If you're going to sync a large directory, you may want to just run 'google-drive-ocamlfuse /your/mount/point' and then use cp or similar to do the initial load.  This is designed to make continual small changes.

If you want to check the state of syncronization manually after mounting your Google Drive, run:

```
$ unison gdrive
```

#### Setup

If you run gdrive-mount, it will either prompt you to do something or create the necessary files to run correctly.

The **one** thing you'll want to edit to fit your needs is gdrive-vars file.  It has the following variables you'll need to set:

* MOUNTPOINT - where you want your Google Drive mounted like ~/google-drive
* LOCALSYNC - the local directory path you want sync'ed with Google Drive
* REMOTESYNC - the path on Google Drive you want sync'ed with LOCALSYNC
* CONFDIR - a hidden directory to store configuration data
* LOGFILE - where you want the log file for auto-magical sync'ing created

Config example:

```
MOUNTPOINT="/home/edexample/google-drive"
LOCALSYNC="/home/edexample/stuff"
REMOTESYNC="/home/edexample/google-drive/stuff"
CONFDIR="/home/edexample/.magic-sync"
LOGFILE="$CONFDIR/sync.log"
```

NOTE:  I used full paths in my testing and regular use.  I'd suggest you do the same.

#### Other considerations

A unison profile is created at $HOME/.unison/gdrive.prf.  If you want to exclude/ignore directories when sync'ing, add them to that file.  There is a commented-out example in the file created during the first run of gdrive-mount.

See [Unison Profiles](http://www.cis.upenn.edu/~bcpierce/unison/download/releases/stable/unison-manual.html#profile) and [Unison Preferences](http://www.cis.upenn.edu/~bcpierce/unison/download/releases/stable/unison-manual.html#prefs) for more info.

#### Running these tools

First, make sure the scripts are executable by you:

```
$ chmod u+x gdrive-mount sync-gdrive unmount-gdrive
```

To mount your Google Drive (after modifying gdrive-vars for your needs):

```
$ ./scripts/gdrive-mount 

Mounting Google Drive under /home/edexample/google-drive

=> Starting an initial bi-directional sync

=> No conflicts found in bi-directional sync

=> Syncing changes from the local directory to Google Drive

=> NOTE: Make changes in your local directory - /home/edexample/stuff so
=> they will automatically propagate to /home/mtesauro/google-drive/stuff.  
=> DO NOT MAKE CHANGES IN /home/mtesauro/google-drive/stuff

=> Use the unmount-gdrive script to safely stop syncing and 
=> unmount Google Drive from your computer

=> NOTE: Execute file permissions do not survive this process
=> since Google Drive doesn't allow exec permissions

ENJOY!
```

When you're ready to unmount Google Drive, run:

```
$ ./scripts/unmount-gdrive 

Unmounting Google Drive from /home/edexample/google-drive

=> Stopping auto-magical syncing

=> Doing a final bi-directional sync

=> No conflicts found in bi-directional sync

Google Drive unmounted from /home/edexample/google-drive

Bye

```

Example of error messages:

```
$ ./scripts/gdrive-mount 

Mounting Google Drive under /home/edexample/google-drive

!! - Google Drive is already mounted at /home/edexample/google-drive
!! - Run 'mount' to see what is currently mounted
!! - To unmount, run 'fusermount -u /home/edexample/google-drive'
!! - or run 'unmount-gdrive' script to unmount it before
!! - running this script again

```

and 

```
$ ./scripts/gdrive-mount 

Mounting Google Drive under /home/edexample/google-drive

=> Starting an initial bi-directional sync

!! - CONFLICTS FOUND during bi-directional sync.  Conflicting file(s):
local          remote     filename
---------------------------------------------
changed  <-?-> changed    problem-child.txt  

Quiting - YOU WILL NEED TO MANUALLY FIX THIS.

Auto-magical syncing will NOT be started until you correct this conflict

Run this command to check conflict status
    unison -batch /home/edexample/stuff /home/edexample/google-drive/stuff 2>/dev/null | grep "<-?->"

Once the conflict is corrected, unmount Google Drive with the 
command below and re-run this script
    fusermount -u /home/edexample/google-drive

$ diff ~/stuff/problem-child.txt ~/google-drive/stuff/problem-child.txt 
13c13
< Content that isn't in the other file
\ No newline at end of file
---
> Make a conflict
\ No newline at end of file
```