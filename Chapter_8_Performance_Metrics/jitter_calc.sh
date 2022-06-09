#!/bin/dash
NODE="$1"
if [ -z "$NODE" ]; then
  echo "USAGE: ./jitter_calc.sh <NODE_N>"
  exit 1
fi
NODE_N=`expr $NODE - 1`
rm -r Jitter/
mkdir -pv Jitter
for conta in $(seq 0 $NODE_N);
do
cat Delay/Delay_$conta.tr | awk -F " " '{
vetor_Delay[NR] = $0
} END {	
	n = 1
	for(i = 0;i < NR; i++){
		jitter = vetor_Delay[n] - vetor_Delay[i]
		if(jitter < 0){
			jitter = (jitter * -1)}	
		printf("%3.9f\n",jitter)
		n++ }}' > Jitter/Jitter_$conta.tr
if [ -s Jitter/Jitter_$conta.tr ]; then
cat Jitter/Jitter_$conta.tr |awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(j = 1; j <= NR; j++){
	soma = soma + Vetor_media[j]}
	media = soma/NR
	printf("%3.9f",media) }' > Jitter/Media_Jitter_$conta.tr
awk -F" " '{print}' Jitter/Media_Jitter_$conta.tr >> Jitter/media.tr
fi
done;
cat Trace_R_S.tr | awk -F" " '{   
	if($1 == "s" && $4 == "AGT"){
		s_pacote[$6]=$2
		snd[$6]=$6 }
	if($1 == "r" && $4 == "AGT"){
		count++
		r_pacote[$6]=$2
		rcv[$6]=$6
		if($6 in r_pacote && $6 in r_pacote && $6 in snd && $6 in rcv){
			delay=r_pacote[$6]-s_pacote[$6]
			printf("%3.9f\n",delay); }}}' > Jitter/Delay_for_Jitter_Network.tr
cat  Jitter/Delay_for_Jitter_Network.tr | awk -F" " '{
count=0;
vetor_EED[NR] = $0;
} END {	
	n = 1
	for(i = 0;i < NR; i++){
		jitter = vetor_EED[n] - vetor_EED[i]
		if(jitter < 0){
			jitter = (jitter * -1)}
		printf("%3.9f\n",jitter)	
		n++ }}' > Jitter/Total_J.tr
cat Jitter/Total_J.tr | awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(j = 1; j <= NR; j++){
	soma = soma + Vetor_media[j]	
	}
	media = soma/NR
	printf("%3.9f",media)
}' > Jitter/Total_Network_Jitter.tr
