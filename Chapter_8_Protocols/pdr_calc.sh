#!/bin/bash
mkdir -pv PDR
cat Trace_Cleaned_AODV.tr | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' \
| sed 's/\:/ /g' \
| awk -F" " '{ {if($2 <= 60.000000000) {print}}}' > Trace_Cleaned_Sujo.tr 
cat Trace_Cleaned_Sujo.tr | uniq > Trace_Cleaned.tr
egrep "^[sr].*AGT.*" Trace_Cleaned.tr > Trace_R_S.tr 
cat Trace_R_S.tr | awk -F " " '{   
	if($1 == "s" && $4 == "AGT"){
		{print}		
	}
 }' > PDR/S.tr 
export s=$(awk -F" " 'END { print NR }' PDR/S.tr)
cat Trace_R_S.tr | awk -F " " '{   
	if($1 == "r" && $4 == "AGT"){
		{print}		
	}
 }' > PDR/R.tr
export r=$(awk -F" " 'END { print NR }' PDR/R.tr)
awk -v S=$s -v R=$r -F " " 'BEGIN {
	PDR = (R/S)*100;
	{print PDR}
}' > PDR/PDR.p
echo $s > PDR/packet_generated.p
echo $r > PDR/packet_received.p
