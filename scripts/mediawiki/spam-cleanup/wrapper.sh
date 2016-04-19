#!/bin/bash

# Wrapper script for clean-spam.sh
# Running this script allows for clean-spam.sh to be run until it exits 
# with a non-zero status (aka an error occurs).  This allows clean-spam
# to be called by itself for individual deletes or by the wrapper to
# bulk delete all pages authored by a spammer.
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

echo "Starting bulk SPAM cleanup"

# Wrap clean-spam.sh to loop through all edits
e="0"
c="0"

# Look until we get a non-zero exit status
while [ $e -eq 0 ]
do
    ./clean-spam.sh
    e=$?
    c=$[$c+1]
    echo "Completed iteration $c"
done

echo "Done with bulk SPAM cleanup - $c pages deleted"

