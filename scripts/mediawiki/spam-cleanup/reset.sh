#!/bin/bash

# Helper script used during development to cleanup any temporary files
# created during the run of clean-spam.sh
# Temp file cleanup has been added to clean-spam.sh so this script
# is only really needed if further development takes place.
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

rm logs/run_*
rm page1 page3 history page4 page5
