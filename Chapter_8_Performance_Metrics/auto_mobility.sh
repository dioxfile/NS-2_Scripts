#!/bin/dash
NN="$1" SP_m="$2" SP_M="$3" SI_T="$4" P_T="$5" X_="$6" Y_="$7" MR_U="$8"
if [ -z "$NN" ]; then
  echo "USAGE: <Nº NODES> <MIN_Speed> <MAX_Speed> <TIME> <PAUSE> <X> <Y> <MIN U_Routes>"
  exit 1
fi
if [ -z "$SP_m" ]; then
  echo "USAGE: <Nº NODES> <MIN_Speed> <MAX_Speed> <TIME> <PAUSE> <X> <Y> <MIN U_Routes>"
  exit 1
fi
if [ -z "$SP_M" ]; then
  echo "USAGE: <Nº NODES> <MIN_Speed> <MAX_Speed> <TIME> <PAUSE> <X> <Y> <MIN U_Routes>"
  exit 1
fi
if [ -z "$SI_T" ]; then
  echo "USAGE: <Nº NODES> <MIN_Speed> <MAX_Speed> <TIME> <PAUSE> <X> <Y> <MIN U_Routes>"
  exit 1
fi
if [ -z "$P_T" ]; then
  echo "USAGE: <Nº NODES> <MIN_Speed> <MAX_Speed> <TIME> <PAUSE> <X> <Y> <MIN U_Routes>"
  exit 1
fi
if [ -z "$X_" ]; then
  echo "USAGE: <Nº NODES> <MIN_Speed> <MAX_Speed> <TIME> <PAUSE> <X> <Y> <MIN U_Routes>"
  exit 1
fi
if [ -z "$Y_" ]; then
  echo "USAGE: <Nº NODES> <MIN_Speed> <MAX_Speed> <TIME> <PAUSE> <X> <Y> <MIN U_Routes>"
  exit 1
fi
if [ -z "$Y_" ]; then
  echo "USAGE: <Nº NODES> <MIN_Speed> <MAX_Speed> <TIME> <PAUSE> <X> <Y> <MIN U_Routes>"
  exit 1
fi
if [ -z "$MR_U" ]; then
  echo "USAGE: <Nº NODES> <MIN_Speed> <MAX_Speed> <TIME> <PAUSE> <X> <Y> <MIN U_Routes>"
  exit 1
fi
export n=$MR_U
while [ $n -ge $MR_U ]
do
./setdest -v2 -n$NN -m$SP_m -M$SP_M -t$SI_T -p$P_T -x$X_ -y$Y_ > mobility.tcl
export sort=$(cat mobility.tcl | egrep "# Destination " | awk -F" " '{{print $4}}')
n=`expr $sort + 0`
echo $n
done
