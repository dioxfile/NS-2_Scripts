#!/bin/dash
FILE="$1"
PACKET_SIZE="$2"
NODE="$3"
if [ -z "$FILE" ]; then
  echo "USAGE: ./throughput_calc.sh <FILE.tr> <PACKET_SIZE> <NODE_N>"
  exit 1
fi
if [ -z "$PACKET_SIZE" ]; then
  echo "USAGE: ./throughput_calc.sh <FILE.tr> <PACKET_SIZE> <NODE_N>"
  exit 1
fi
if [ -z "$NODE" ]; then
  echo "USAGE: ./throughput_calc.sh <FILE.tr> <PACKET_SIZE> <NODE_N>"
  exit 1
fi
NODE_N=`expr $NODE - 1`
rm -r Throughput/
mkdir -pv Throughput
cat $FILE | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' | \
sed 's/\:/ /g' > Trace_Cleaned.tr
egrep "^[sr].*AGT.*" Trace_Cleaned.tr > Trace_R_S.tr 
for conta in $(seq 0 $NODE_N); do 
cat Trace_R_S.tr | awk -F " " 'BEGIN{ 
lineCount = 0;
totalBits = 0
duration = 0;
}
{if($1=="s" && lineCount==0){ 
	timeBegin = $2; lineCount++
} else {
	timeEnd = $2;
}}
/^r/&&$4=="AGT"&&$24=="'$conta'"{
	if ($8=="'$PACKET_SIZE'") {
		totalBits += $8-20;
   } else {
		totalBits += $8;
   };};
END{
duration = timeEnd-timeBegin;
	if(duration > 0 ) { 
		Thoughput = (totalBits*8)/duration/1e3;
		printf("%3.5f",Thoughput);
	}
};' > Throughput/Throughput_$conta.tr
if [ -s Throughput/Throughput_$conta.tr ]; then
awk -F" " '{{if($1!=0.0){{print}}}}' Throughput/Throughput_$conta.tr >> Throughput/mediaV.tr
fi
done;
