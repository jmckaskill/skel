#!/bin/bash
#Global session stuff
#setxkbmap -layout us -variant dvorak
xmodmap .xmodmaprc
kdeinit &
#Left screen
amarok &
psi &
wmii &
#Right Screen
#export DISPLAY="`echo ${DISPLAY} | sed 's#\.0#.1#g'`"
export DISPLAY=:0.1
synergys &
urxvt &
wmii
#ion3 
#startkde
