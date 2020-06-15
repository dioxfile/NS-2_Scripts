#!/bin/bash
mkdir -pv Delay
rm Delay/media.tr
cat Trace_Cleaned_DSR.tr | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' \
| sed 's/\:/ /g' \
| awk -F" " '{ {if($2 <= 60.000000000) {print}}}' > Trace_Cleaned_Sujo.tr 
cat Trace_Cleaned_Sujo.tr | uniq > Trace_Cleaned.tr
egrep "^[sr].*AGT.*" Trace_Cleaned.tr > Trace_R_S.tr 
for conta in $(seq 0 59); do
cat Trace_R_S.tr | awk -F " " '{   
	if($1 == "s" && $3=="'$conta'" && $4 == "AGT"){
		s_pacote[$6] = $2
		svetor[$6]=$6			
	}
	if($1 == "r" && $4 == "AGT"){
		r_pacote[$6] = $2
		rvetor[$6]=$6
	}
} END {	
	for(t = 0; t < NR; t++){
	  if(t in r_pacote && t in s_pacote && t in svetor && t in rvetor){
		 if(svetor[t]==rvetor[t]){	
				delay = (r_pacote[t] - s_pacote[t])*1000
				printf ("%3.9f\n",delay)
			}
		}
	}
}' > Delay/Delay_$conta.tr
if [ -s Delay/Delay_$conta.tr ]; then
cat Delay/Delay_$conta.tr |awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(m = 1; m <= NR; m++){
	soma = soma + Vetor_media[m]	
	}
	media = (soma/NR)
	printf("%3.9f",media)
}' > Delay/Media_Delay_$conta.tr
awk -F" " '{print}' Delay/Media_Delay_$conta.tr >> Delay/media.tr
fi
done;
