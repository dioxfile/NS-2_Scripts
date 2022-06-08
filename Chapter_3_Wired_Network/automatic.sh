#!/bin/sh
NN="$1"
SEED="$2"
MC="$3"
RATE="$4"
if [ -z "$NN" ]; then
  echo "USAGE: <Nº NODES> <VAL SEED> <Nº CONNCT> <RATE_KBPS>"
  exit 1
fi
if [ -z "$SEED" ]; then
 echo "USAGE: <Nº NODES> <VAL SEED> <Nº CONNCT> <RATE_KBPS>"
  exit 1
fi
if [ -z "$MC" ]; then
 echo "USAGE: <Nº NODES> <VAL SEED> <Nº CONNCT> <RATE_KBPS>"
  exit 1
fi
if [ -z "$RATE" ]; then
   echo "USAGE: <Nº NODES> <VAL SEED> <Nº CONNCT> <RATE_KBPS>"
  exit 1
fi
while [ "$sort" != "$MC/$MC" ]
do
  ns cbrgen.tcl -type cbr -nn $NN -seed $SEED -mc $MC -rate $RATE > traffic.tcl
  export sort=$(cat traffic.tcl | egrep "#Total " | awk -F" " '{if($3=="'$MC/$MC'") {print $3}}')
  echo $sort
done
