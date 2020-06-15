#!/bin/bash
mkdir -pv Overhead
cat TRACE_FILE.tr | sed 's/\[//g' | sed 's/\]//g' \
| sed 's/\_//g' | sed 's/\:/ /g' \
| awk -F" " '{ {if($2 <= 60.000000000) {print}}}' > Trace_Cleaned_Sujo.tr 
cat Trace_Cleaned_Sujo.tr | uniq > Trace_Cleaned.tr
cat Trace_Cleaned.tr | awk -F" " '{if($1=="s" && $4=="MAC" && ($7=="OLSR" \
	|| $7=="AODV" || $7=="DSR" || $7=="message")){{print}}}' > Overhead/OVER.tr
awk -F" " 'END { print NR }' Overhead/OVER.tr > Overhead/Overhead.tr 
for conta in $(seq 0 59); do
cat  Overhead/OVER.tr | awk -F" " '{
	if($3=="'$conta'")
	{print}
}' > Overhead/OVER_By_$conta.ov
if [ ! -s Overhead/OVER_By_$conta.ov ]; then
echo "File Overhead/OVER_By_$conta.ov is empty!"
echo "0" > Overhead/OVER_By_$conta.ov
else
echo "File Overhead/OVER_By_$conta.ov isn't empty!"
fi
awk -F" " 'END {if($1=="0") {print NR==0} else {print NR}}' \
Overhead/OVER_By_$conta.ov >> Overhead/Overhead_by_no.tr
done;
export OH=$(cat Overhead/OVER.tr | awk -F " " 'BEGIN {OH = 0;} \
/^s/&&$4=="MAC"{OH=OH+$8}; END {printf("%f\n"), OH;}')
export DATA=$(cat Trace_Cleaned.tr | awk -F " " 'BEGIN {DATA = 0;} \
/^r/&&$4=="AGT"{DATA=DATA+$8}; END {printf("%f\n"), DATA;}')
echo $OH > Overhead/OH_Bytes.b
echo $DATA > Overhead/DATA_Bytes.b
awk -v overhead=$OH -v data=$DATA -F" " 'BEGIN { print (overhead/data)*100}' \
> Overhead/Overhead_R.tr
echo "End Routing Overhead Calculation!!!"
