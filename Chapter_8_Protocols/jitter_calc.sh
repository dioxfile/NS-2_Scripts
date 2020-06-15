#!/bin/bash
mkdir -pv Jitter
for conta in $(seq 0 59);
do
cat Delay/Delay_$conta.tr | awk -F " " '{
vetor_Delay[NR] = $0
} END {	
	n = 1
	for(i = 0;i < NR; i++){
		jitter = vetor_Delay[n] - vetor_Delay[i]
		if(jitter < 0){
			jitter = (jitter * -1)
		}	
		printf("%3.9f\n",jitter)
		n++
	}
}' > Jitter/Jitter_$conta.tr
if [ -s Jitter/Jitter_$conta.tr ]; then
cat Jitter/Jitter_$conta.tr |awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(j = 1; j <= NR; j++){
	soma = soma + Vetor_media[j]	
	}
	media = soma/NR
	printf("%3.9f",media)
}' > Jitter/Media_Jitter_$conta.tr
awk -F" " '{print}' Jitter/Media_Jitter_$conta.tr >> Jitter/media.tr
fi
done;
