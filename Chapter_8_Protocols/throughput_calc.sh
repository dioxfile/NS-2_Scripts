#!/bin/sh
mkdir -pv Throughput
cat Trace_Cleaned_DSR.tr | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' | \
sed 's/\:/ /g' \
| awk -F" " '{ {if($2 <= 60.000000000) {print}}}' > Trace_Cleaned_Sujo.tr 
cat Trace_Cleaned_Sujo.tr | uniq > Trace_Cleaned.tr
for conta in $(seq 0 59); do 
cat Trace_Cleaned.tr | awk -F " " 'BEGIN{ 
lineCount = 0;
totalBits = 0;
}
/^r/&&$4=="AGT"&&$24=="'$conta'"{
   if ($8==270) {
		totalBits += 8*($8-20);
   }else {
		totalBits += 8*$8;
   };
   if (lineCount==0) {
		timeBegin = $2;
		lineCount++;
   }else {
		timeEnd = $2;
   };
};
END{
duration = timeEnd-timeBegin;
if(timeEnd==0) {
	duration = 1;
} 	
Thoughput = totalBits/duration/1e3;
	printf("%3.5f",Thoughput);
};' > Throughput/Throughput_$conta.tr
done;
