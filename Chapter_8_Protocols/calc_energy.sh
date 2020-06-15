#!/bin/bash
mkdir -pv Energy
cat Trace_Cleaned_DSR.tr | sed 's/\[//g' | sed 's/\]//g' | sed 's/\:/ /g' \
| awk -F" " '{ {if($2 <= 60.000000000) {print}}}' > Trace_Cleaned_Sujo.tr 
cat Trace_Cleaned_Sujo.tr | uniq > Trace_Cleaned.tr
egrep "^N.*" Trace_Cleaned.tr > Energy/Energia_total.e 
cat Energy/Energia_total.e | awk -F" " '{print $5 " " $7 " " $3}' > \
Energy/Energia_total_col_nodo_energy.e 
for conta in $(seq 0 59); do
cat Energy/Energia_total_col_nodo_energy.e  | \
awk -F" " '{if($1=="'$conta'"){print $3 " " $2}}' > \
Energy/Energia_total_$conta.e 
cat Energy/Energia_total_$conta.e | \
awk -F" " 'END { print (100.000000 - $2) }' \
> Energy/Energia_Final_$conta.e
cat  Energy/Energia_Final_$conta.e >> Energy/Energia_Final_Geral.e
done;
