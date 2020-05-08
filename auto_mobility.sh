#!/bin/sh
export n=1
while [ $n -ge 1 ]
do
./setdest -v2 -n3 -m5.0 -M20.0 -t50 -p3 -x1000 -y1000 > mobility.tcl
export sort=$(cat mobility.tcl | egrep "# Destination " |
awk -F" " '{{print $4}}')
n=`expr $sort + 0`
echo $n
done
