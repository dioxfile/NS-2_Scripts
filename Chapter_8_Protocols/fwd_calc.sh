#!/bin/bash
mkdir -pv Forward
cat TREACE_FILE.tr | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' \
| sed 's/\:/ /g' \
| awk -F" " '{ {if($2 <= 60.000000000) {print}}}' > Trace_Cleaned_Sujo.tr 
cat Trace_Cleaned_Sujo.tr | uniq > Trace_Cleaned.tr
cat Trace_Cleaned.tr | egrep "^f.*" | awk -F" " '{if($7=="cbr" \
	|| $7=="tcp") {{print}}}'> Forward/FWD_ALL.tr	
awk -F" " 'END { print NR }' Forward/FWD_ALL.tr > Forward/Forward_ALL_Number.tr
for conta in $(seq 0 59); do
cat Forward/FWD_ALL.tr | awk -F" " '{
	if($3=="'$conta'") {print}}' > Forward/FWD_ALL_By_$conta.f
if [ ! -s Forward/FWD_ALL_By_$conta.f ]; then
echo "File Forward/FWD_ALL_By_$conta.f is empty!"
echo "0" > Forward/FWD_ALL_By_$conta.f
else echo "File Forward/FWD_ALL_By_$conta.f isn't empty!" 
fi
awk -F" " 'END {if($1=="0") {print NR==0} else {print NR}}' \
Forward/FWD_ALL_By_$conta.f >> Forward/Forward_by_no.tr 
done;
cat Forward/FWD_ALL.tr | awk -F" " '{print $3 " " $6 " " $24 " " $26}' > \
Forward/FWD_UNIQ.tr
cat Forward/FWD_UNIQ.tr | awk -F" " '{{print $2}}' | uniq -u > \
Forward/FWD_UNIQ_PKID.tr
cat Forward/FWD_UNIQ_PKID.tr | awk -F " " 'END{print NR}' > \
Forward/FWD_UNIQ_PKID_Number.tr
cat Trace_Cleaned.tr | awk -F" " '{if($1=="r" && $4=="AGT"){{print \
	$6}}}' > Forward/RCV.tr
rm -v Forward/UNIQ_PKID_RCV_F.tr
cat Forward/RCV.tr | awk -F " " '{print}' > Forward/UNIQ_PKID_RCV_F.tr
cat Forward/FWD_UNIQ_PKID.tr | awk -F " " '{print}' >> Forward/UNIQ_PKID_RCV_F.tr	
sort -n Forward/UNIQ_PKID_RCV_F.tr | uniq -d > Forward/FWD_Effective.tr 
awk -F" " 'END { print NR}' Forward/FWD_Effective.tr > \
Forward/FWD_Effective_Number.tr  
cat Forward/FWD_UNIQ_PKID_Number.tr > Forward/Forward_TMP_SUCCESS.tr 
cat Forward/FWD_Effective_Number.tr >> Forward/Forward_TMP_SUCCESS.tr 
cat Forward/Forward_TMP_SUCCESS.tr | awk -F " " '{ 
FWD[NR] = $0 } END { SUCCESS = (FWD[2]/FWD[1])*100 
	printf("%.f %",SUCCESS)}' > \
Forward/Forward_SUCCESS.tr 
