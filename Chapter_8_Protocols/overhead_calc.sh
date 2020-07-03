#!/bin/dash
FILE="$1"
NODE="$2"
if [ -z "$FILE" ]; then
  echo "USAGE: ./overhead_calc.sh <FILE.tr> <NODE_N>"
  exit 1
fi
if [ -z "$NODE" ]; then
  echo "USAGE: ./overhead_calc.sh <FILE.tr> <NODE_N>"
  exit 1
fi
NODE_N=`expr $NODE - 1`
rm Overhead/ -r
mkdir -pv Overhead
cat $FILE | sed 's/\[//g' | sed 's/\]//g' \
| sed 's/\_//g' | sed 's/\:/ /g' > Trace_Cleaned.tr
cat Trace_Cleaned.tr | awk -F" " '{if(($1=="s" || $1=="f") && $4=="RTR" &&  ($7=="OLSR" \
	|| $7=="AODV" || $7=="DSR" || $7=="message")){{print}}}' > Overhead/OVER.tr
awk -F" " 'END { print NR }' Overhead/OVER.tr > Overhead/Overhead.tr 
for conta in $(seq 0 $NODE_N); do
cat  Overhead/OVER.tr | awk -F" " '{
	if($3=="'$conta'")
	{print}
}' > Overhead/OVER_By_$conta.ov
if [ ! -s Overhead/OVER_By_$conta.ov ]; then
echo "0" > Overhead/OVER_By_$conta.ov
fi
awk -F" " 'END {if($1=="0") {print NR==0} else {print NR}}' \
Overhead/OVER_By_$conta.ov >> Overhead/Overhead_by_no.tr
done;
export OH=$(cat Overhead/OVER.tr | awk -F " " 'BEGIN {OH = 0;} \
/^[sf]/&&$4=="RTR"{OH=OH+$8}; END {printf("%f\n"), OH;}')
export DATA=$(cat Trace_Cleaned.tr | awk -F " " 'BEGIN {DATA = 0;} \
/^r/&&$4=="AGT"{DATA=DATA+$8}; END {printf("%f\n"), DATA;}')
export NOH=$(cat Overhead/Overhead.tr | awk -F" " 'END{ print }')
export NDATA=$(awk -F" " 'END { print NR }' Packet_Loss/R.tr)
echo $OH > Overhead/OH_Bytes.b
echo $DATA > Overhead/DATA_Bytes.b
awk -v overhead=$OH -v data=$DATA -F" " 'BEGIN { \
	print (overhead/data)*100}' > Overhead/Overhead_R.tr
awk -v noverhead=$NOH -v ndata=$NDATA -F" " 'BEGIN { \
	print (noverhead/ndata)*100}' > Overhead/Overhead_Normalized.tr
