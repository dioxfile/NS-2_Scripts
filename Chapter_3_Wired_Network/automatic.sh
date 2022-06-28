#!/bin/sh
TYPE_T="$1"
NN="$2"
SEED="$3"
MC="$4"
RATE="$5"
if [ -z "$TYPE_T" ]; then
  echo "USAGE: <TYPE_TRAFFIC> <Nº NODES> <VAL SEED> <Nº CONNCT> <RATE_KBPS>"
  exit 1
fi
if [ -z "$NN" ]; then
  echo "USAGE: <TYPE_TRAFFIC> <Nº NODES> <VAL SEED> <Nº CONNCT> <RATE_KBPS>"
  exit 1
fi
if [ -z "$SEED" ]; then
  echo "USAGE: <TYPE_TRAFFIC> <Nº NODES> <VAL SEED> <Nº CONNCT> <RATE_KBPS>"
  exit 1
fi
if [ -z "$MC" ]; then
  echo "USAGE: <TYPE_TRAFFIC> <Nº NODES> <VAL SEED> <Nº CONNCT> <RATE_KBPS>"
  exit 1
fi
if [ -z "$RATE" ]; then
  echo "USAGE: <TYPE_TRAFFIC> <Nº NODES> <VAL SEED> <Nº CONNCT> <RATE_KBPS>"
  exit 1
fi
while [ "$sort" != "$MC/$MC" ]
do
    ns cbrgen.tcl -type $TYPE_T -nn $NN -seed $SEED -mc $MC -rate $RATE > traffic.tcl
    export sort=$(cat traffic.tcl | egrep "#Total " | awk -F" " '{if($3=="'$MC/$MC'") {print $3}}')
    echo $sort
done
