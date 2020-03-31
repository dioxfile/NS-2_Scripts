#!/bin/sh
while [ "$sort" != "10/10" ]
do
ns cbrgen.tcl -type cbr -nn 50 -seed 0.75 -mc 10 \ 
-rate 128.0 > traffic.tcl
export sort=$(cat traffic.tcl | egrep "#Total " \ 
| awk -F" " '{if($3=="10/10") {print $3}}')
echo $sort
done
