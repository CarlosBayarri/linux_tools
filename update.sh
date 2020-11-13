#!/bin/bash
sudo apt-get update
echo "y" | sudo apt-get upgrade
echo "System upgraded"
DATE0=$(date +%d-%m-%y-%T)
notify-send "System uptodate" $DATE0
echo $DATE0
