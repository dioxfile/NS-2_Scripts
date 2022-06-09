#!/bin/dash
FILE="$1"
if [ -z "$FILE" ]; then
  echo "USAGE: ./drop_packet_calc.sh <FILE.tr>"
  exit 1
fi
rm -r Packet_Loss/
mkdir -pv Packet_Loss
cat $FILE | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' \
| sed 's/\:/ /g' > Trace_Cleaned.tr
egrep "^[sr].*AGT" Trace_Cleaned.tr > Trace_R_S.tr 
cat Trace_R_S.tr | awk -F " " '{   
	if($1 == "s" && $4 == "AGT"){
		{print}		
	}
 }' > Packet_Loss/S.tr 
export s=$(awk -F" " 'END { print NR }' Packet_Loss/S.tr)
cat Trace_R_S.tr | awk -F " " '{   
	if($1 == "r" && $4 == "AGT"){
		{print}		
	}
 }' > Packet_Loss/R.tr
export r=$(awk -F" " 'END { print NR }' Packet_Loss/R.tr)
awk -v S=$s -v R=$r -F " " 'BEGIN {
	PLR = S - R;
	{print PLR}
}' > Packet_Loss/PLR_U.p
awk -v S=$s -v R=$r -F " " 'BEGIN {
	PLR = S - R;
	{print (PLR/S)*100}
}' > Packet_Loss/PLR_R.p
echo $s > Packet_Loss/packet_generated.p
echo $r > Packet_Loss/packet_received.p
