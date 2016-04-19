#!/bin/bash

# This script will take find all contributions from $PUNK and delete the pages with
# $PUNK as an editor ONLY IF the authors of that page are the ones listed in 
# $AUTHORS.
#
# If it finds a wiki page that has other authors, the wiki session times
# out, or other issues, the URLs are listed in a file called skipped_[day].txt
# e.g. skipped_2016-04-19.txt so that those URLs can be manually inspected.
#
# Required info to run this:
# USR - set to the wiki username who will be doing the deleting
# PUNK - set the the username of the spammer
# AUTHORS - set to the username(s) of spammers or wiki maint scripts, pipe
#           delineated - see example below.
# HOST - set to the hostname of the MediaWiki server
# A file called "cookies.txt" which contains the cookie values from a 
# valid session with the wiki. One way to collect this is to log into the
# MediaWiki instance with a browser and a local proxy such as OWASP ZAP.
# The cookie values can be copy/pasted out of proxy's captured HTTP traffic.
# 
# Created by Matt Tesauro on Tue, 19 Apr 2016 09:38:56 -0500
#
#     This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

USR="Mtesauro"
PUNK="Nishuyadav257"
AUTHORS='User:Nishuyadav257|User:Pa306013|User_talk:Maintenance_script'
START=`date +"%Y-%m-%d_%T"`
LOG="logs/run_$START.txt"
HOST="https://www.owasp.org"
DAY=`date +"%Y-%m-%d"`
SKIP="skipped_$DAY.txt"

# Define a timestamp function
timestamp() {
    date +"%T"
}

# Define a logging function
logger() {
    timestamp | tr '\n' ' ' >> $LOG
    echo $1 >> $LOG
}

# Create the logs subdirectory if it doesn't exist
if [ ! -d logs ] ; then
	mkdir logs
	logger "Created logs direcotry to store logging data" $LOG
fi

# Read in cookie values from the file
COOKIES=`cat cookies.txt`

# Pull the user contrib page for $PUNK
URL1="$HOST/index.php?title=Special%3AContributions&tagfilter=&contribs=user&target=$PUNK&namespace=&year=2016&month=-1"

logger "Pulling user $PUNK contribs from $URL1" $LOG

curl -q -X GET "$URL1" --cookie "$COOKIES" 2>/dev/null > page1 

logger "Saved $PUNK contribs as page1" $LOG

# Check if cookies are stale
# ToDo - pull username from $COOKIES 
COOKIECK=`grep "$USR" page1 | wc -l`
if [ $COOKIECK -eq 0 ]; then
   logger "BAILING OUT - Cookies are stale" $LOG;
   logger "Check the cookies.txt file values and try again" $LOG;
   exit 1;
fi

# Check to see if there are no more contributions listed for this User
NOCONTRIBS=`grep "No changes were found" page1 | wc -l`
if [ $NOCONTRIBS -ne 0 ]; then
   logger "BAILING OUT - No contributions were found for $PUNK" $LOG;
   logger "Check the $LOG file and confirm by viewing contributions page in a browser" $LOG;
   exit 1;
fi

# Pull first contrib from the punk by getting the line before and adding 1
BEFORE=`grep -n '"mw-numlink">500' page1 | head -n 1 | cut --delimiter=":" --field=1`
MATCH=$((BEFORE + 1))

logger "Line before is $BEFORE and matched line is $MATCH" $LOG

# Pull out the URI from the first contrib of the punk to create the URL2 - their first contribution
URI2=`cat page1 | sed -n 93p | cut --delimiter="\"" --field=2`
URL2="$HOST$URI2"

logger "URL of first contrib from $PUNK is $URL2" $LOG

# Convert the contrib page to the history to that page
URL3=`echo -n $URL2 | sed -n "s/&amp.*$//p"`"&action=history"

# Request the history of that page to check who the authors are listed
curl -q -X GET "$URL3" --cookie "$COOKIES" 2>/dev/null > page3

logger "Requesting page history of $PUNK's first contrib using $URL3" $LOG

# Get the history of page edits
cat page3 | grep 'history-user' > history

# Get the number of edits
EDITS=`cat history | wc -l`

logger "History of $PUNK's first contribs has $EDITS edits" $LOG

# Get the count of authors in our list of punk authors + wiki maintenance_script user
AUTHCNT=`grep -E 'User:Nishuyadav257|User:Pa306013|User_talk:Maintenance_script' history | wc -l`

# If author count is 0, there's a problem or there are no more page contributions
if [ $COOKIECK -eq 0 ]; then
   logger "BAILING OUT - None of the $AUTHORS were found" $LOG;
   logger "Check the $LOG file and try again" $LOG;
   exit 1;
fi

logger "Count of authors $AUTHORS in $PUNK's first contribs is $AUTHCNT" $LOG

# Check that the only edits are from our list of punk authors
if [ "$EDITS" == "$AUTHCNT" ] ; then
    # Page should be deleted
    logger "Edits = Authors - Deleting page at $URL2" $LOG
    
    # Create the delete URL
    URL4=`echo -n $URL2 | sed -n "s/&amp.*$//p"`"&action=delete"
    
    # Call the form to delete this page
    curl -q -X GET "$URL4" --cookie "$COOKIES" 2>/dev/null > page4
    
    logger "Called the page deletion form at $URL4" $LOG
    
    # Check for "not have permission" in page4 because that means cookie is stale
    DELCHECK=`grep "not have permission" page4 | wc -l`
    if [ "$DELCHECK" == "0" ] ; then 
        logger "Auth check passed for $URL4" $LOG
        logger "Deleting page from $PUNK at $URL2" $LOG
        
        # Pull out the wpEditToken from the delete form for the POST submission
        TOK=`grep "wpEditToken" page4 | cut --delimiter="=" --field=3 | cut --delimiter="\"" --field=2 | cut --delimiter="+" --field=1`
        
        # Submit the delete form with the necessary parameters - a POST to URL4
        DATA="wpDeleteReasonList=Spam&wpReason=content+was+SPAM&wpConfirmB=Delete+page&wpEditToken=$TOK%2B%5C"
        
        curl -q -X POST "$URL4" --cookie "$COOKIES" --data "$DATA" 2>/dev/null > page5
        
        # Check that the delete was successful
        SUCCESS=`grep "<title>" page5 | grep "Action complete" | wc -l`
        if [ "$SUCCESS" == "1" ] ; then
            # Successful delete
            logger "Success deleting $URL2" $LOG
            logger "One less page created by $PUNK on the wiki :-)" $LOG
        else
            # Failed delete - shouldn't see this (probably)
            logger "Failure deleting $URL2" $LOG
            logger "Not sure what happened - adding to skipped log" $LOG
            echo "Failed delete POST for URL below:" >> $SKIP
            echo "$URL4" >> $SKIP
        fi
        
    else
        # Auth failed for the delete page
        logger "FAILED AUTH for delete page form at $URL4 - skipping this URL" $LOG
        echo "Stale cookies for URL below:" >> $SKIP
        echo "$URL4" >> $SKIP
    fi
    
else
    # Page has additional authors - note in a file and skip deletion
    logger "Edits != Authors - Skipping page at $URL2" $LOG
    echo "$URL2" >> $SKIP
fi

# Clean up temp files
logger "Cleaning up temporary files" $LOG
rm page1 page3 history page4 page5

# exit with a zero
exit 0
