#!/bin/bash
mkdir -pv Packet_Loss
cat TRACE_FILE.tr| sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' \
| sed 's/\:/ /g' \
| awk -F" " '{ {if($2 <= 60.000000000) {print}}}' > Trace_Cleaned_Sujo.tr 
cat Trace_Cleaned_Sujo.tr | uniq > Trace_Cleaned.tr
egrep "^[sr].*AGT.*" Trace_Cleaned.tr > Trace_R_S.tr 
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
