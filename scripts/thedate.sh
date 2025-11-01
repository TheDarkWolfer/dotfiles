#!/usr/bin/env bash

date +"%a. %B $(date +%-d)$(date +%-d | awk '{ 
  if (11 <= $1 && $1 <= 13) {print "th"} 
  else if ($1 % 10 == 1) {print "st"} 
  else if ($1 % 10 == 2) {print "nd"} 
  else if ($1 % 10 == 3) {print "rd"} 
  else {print "th"} 
}')"
