#!/bin/bash
echo "Cleanning Trace..."
cat TRACE_Arquivo.tr | sed 's/\[//g' | sed 's/\]//g' | sed 's/\:/ /g' \
| awk -F" " '{ {if($2 <= 60.000000000) {print}}}' > Trace_Cleaned_Sujo.tr 
cat Trace_Cleaned_Sujo.tr | uniq > Trace_Cleaned.tr

## Quantity of Couple Sources/Destinies Ex.: $(seq 0 1) == 2
for sim in $(seq 0 1);
do
if [ $sim == 0 ]; then
    s=35
    d=3
else
    s=49
    d=16
fi
cat Trace_Cleaned.tr | awk -v fromNode=$s -v toNode=$d -F " " 'BEGIN {
lineCount = 0;totalBits = 0;
}
/^r/&&$4=="AGT"&&$24==fromNode&&$26==toNode {
    totalBits += 8*($8-20);
    if ( lineCount==0 ) {
        timeBegin = $2; lineCount++;
    } else {
        timeEnd = $2;
    };
};
END{
    duration = timeEnd-timeBegin;
    print "Number of records is " NR;
    print "Output: ";
    print "Transmission: N" fromNode "->N" toNode; 
    print "  - Total transmitted bits = " totalBits " bits";
    print "  - duration = " duration " s"; 
    print "  - Thoughput = "  totalBits/duration/1e3 " kbps.";     
};'
done;
######   Dropped Packet Calculation   ######
#/// Level 1
#Print file with all packages marked with events 's' and 'r'
egrep "^[sr].*AGT.*" Trace_Cleaned.tr > Trace_R_S.tr 
cat Trace_R_S.tr | awk -F " " '{   
	if($1 == "s" && $4 == "AGT"){
		{print}		
	}
 }' > S.tr 
#Store the Quantity of Packet was Sent by the Source
export S=$(awk -F" " 'END { print NR }' S.tr)
#/// level 2
#Print file with all packages marked with event 'r'
cat Trace_R_S.tr | awk -F " " '{   
	if($1 == "r" && $4 == "AGT"){
		{print}		
	}
 }' > R.tr
#Store the Quantity of Packet was Received by the Destiny 
export R=$(awk -F" " 'END { print NR }' R.tr)
######      END Dropped Packet Calculation   ########
PLR=`expr $S - $R`
printf "\n\n\n"
echo "#####   DROPPED PACKETS   #####"
echo "  - Total Packets Generated = $S" ;
echo "  - Packet Loss Rate (PDR) = $PLR";
