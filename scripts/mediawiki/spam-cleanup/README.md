### MediaWiki Spam Cleanup helpers

Some tools to help clean-up MediaWiki when Internet punks decide to SPAM
your wiki.

clean-spam.sh and wrapper.sh were written when some spammers added a bunch
of pages to a MediaWiki install.  The usual tools - SpecialPages:Mass Delete
and maintenance/deleteBatch.php didn't fit this situation.  Both of those
tools look for either page creations or the most recent edits from the 
spammer. [1]

In this case, multiple spammer accounts edited and re-edited after eachother
creating a situation that didn't fit the default tools.

The clean-spam.sh will take find all contributions from a MediaWiki user 
and delete the pages with them as an editor/author ONLY IF the authors of
that page are listed in the AUTHORS variable.

If it finds a wiki page that has other authors, the wiki session times
out, or other issues, the URLs are listed in a file called skipped_[day].txt
e.g. skipped_2016-04-19.txt so that those URLs can be manually inspected.

#### Setup

Required info to run this:

* USR - set to the wiki username who will be doing the deleting
* PUNK - set the the username of the spammer
* AUTHORS - set to the username(s) of spammers or wiki maint scripts, pipe delineated - see example below.
* HOST - set to the hostname of the MediaWiki server
* A file called "cookies.txt" which contains the cookie values from a valid session with the wiki. 

Config example:

```
USR="Mtesauro"
PUNK="Nishuyadav257"
AUTHORS='User:Nishuyadav257|User:Pa306013|User_talk:Maintenance_script'
HOST="https://www.owasp.org"
```

Cookies file example:

```
$ cat cookies.txt 
wikiUserName=Wuser; wikiLoggedOut=1461016441; wiki_session=[session id here]; wikiUserID=7777;
```

One way to collect this is to log into the MediaWiki instance with a browser and a local proxy such as OWASP ZAP. The cookie values can be copy/pasted out of proxy's captured HTTP traffic.  An example with bogus values in included in this repo.

#### Running these tools

clean-spam.sh is designed to delete a single page per run.  This allows it to be used to clean up a specific instance or used with wrapper.sh to run until it exits with a non-zero exit status aka an error.  clean-spam.sh logs all its actions in a directory called 'logs' which is created in the working directory if it doesn't already exist.  The wrapper.sh script outputs each iteration of clean-spam.sh to let you know how many times its run.  An example run is below:

```
$ ./wrapper.sh
Starting bulk SPAM cleanup
Completed iteration 1
Completed iteration 2
Completed iteration 3
Completed iteration 4
Completed iteration 5
Completed iteration 6
Completed iteration 7
  [bunch of lines removed]
Completed iteration 75
Completed iteration 76
Done with bulk SPAM cleanup - 76 pages deleted
```

Example of log files from various runs of clean-spam.sh:

```
$ cat logs/run_2016-04-19_01\:05\:47.txt
1:05:47 Pulling user Nishuyadav257 contribs from https://www.owasp.org/index.php?title=Special%3AContributions&tagfilter=&contribs=user&target=Nishuyadav257&namespace=&year=2016&month=-1
01:05:47 Saved Nishuyadav257 contribs as page1
01:05:47 Line before is and matched line is 1
01:05:47 URL of first contrib from Nishuyadav257 is https://www.owasp.org/index.php?title=Q.u.i.c.k.B.o.o.k.s_tecH_suPPort_Numbner!!((_1_..888..513..5978_))_Intuit_Quickbooks_%2BEnterprise_%2BCustomer_support_Phone_Number&amp;oldid=213199
01:05:48 Requesting page history of Nishuyadav257's first contrib using https://www.owasp.org/index.php?title=Q.u.i.c.k.B.o.o.k.s_tecH_suPPort_Numbner!!((_1_..888..513..5978_))_Intuit_Quickbooks_%2BEnterprise_%2BCustomer_support_Phone_Number&action=history
01:05:48 History of Nishuyadav257's first contribs has 3 edits
01:05:48 Count of authors User:Nishuyadav257|User:Pa306013|User_talk:Maintenance_script in Nishuyadav257's first contribs is 3
01:05:48 Edits = Authors - Deleting page at https://www.owasp.org/index.php?title=Q.u.i.c.k.B.o.o.k.s_tecH_suPPort_Numbner!!((_1_..888..513..5978_))_Intuit_Quickbooks_%2BEnterprise_%2BCustomer_support_Phone_Number&amp;oldid=213199
01:05:49 Called the page deletion form at https://www.owasp.org/index.php?title=Q.u.i.c.k.B.o.o.k.s_tecH_suPPort_Numbner!!((_1_..888..513..5978_))_Intuit_Quickbooks_%2BEnterprise_%2BCustomer_support_Phone_Number&action=delete
01:05:49 Auth check passed for https://www.owasp.org/index.php?title=Q.u.i.c.k.B.o.o.k.s_tecH_suPPort_Numbner!!((_1_..888..513..5978_))_Intuit_Quickbooks_%2BEnterprise_%2BCustomer_support_Phone_Number&action=delete
01:05:49 Deleting page from Nishuyadav257 at https://www.owasp.org/index.php?title=Q.u.i.c.k.B.o.o.k.s_tecH_suPPort_Numbner!!((_1_..888..513..5978_))_Intuit_Quickbooks_%2BEnterprise_%2BCustomer_support_Phone_Number&amp;oldid=213199
01:05:50 Success deleting https://www.owasp.org/index.php?title=Q.u.i.c.k.B.o.o.k.s_tecH_suPPort_Numbner!!((_1_..888..513..5978_))_Intuit_Quickbooks_%2BEnterprise_%2BCustomer_support_Phone_Number&amp;oldid=213199
01:05:50 One less page created by Nishuyadav257 on the wiki :-)
01:05:50 Cleaning up temporary files
```

The final log file will look like:

```
$ cat logs/run_2016-04-19_01\:05\:50.txt
01:05:50 Pulling user Nishuyadav257 contribs from https://www.owasp.org/index.php?title=Special%3AContributions&tagfilter=&contribs=user&target=Nishuyadav257&namespace=&year=2016&month=-1
01:05:51 Saved Nishuyadav257 contribs as page1
01:05:51 BAILING OUT - No contributions were found for Nishuyadav257
01:05:51 Check the logs/run_2016-04-19_01:05:50.txt file and confirm by viewing contributions page in a browser
```

[1] https://www.mediawiki.org/wiki/Manual:Combating_vandalism#Standard_cleanup_tools
