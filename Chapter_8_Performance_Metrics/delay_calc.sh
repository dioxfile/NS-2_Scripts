#!/bin/dash
FILE="$1"
NODE="$2"
if [ -z "$FILE" ]; then
  echo "USAGE: ./delay_calc.sh <FILE.tr> <NODE_N>"
  exit 1
fi
if [ -z "$NODE" ]; then
  echo "USAGE: ./delay_calc.sh <FILE.tr> <NODE_N>"
  exit 1
fi
NODE_N=`expr $NODE - 1`
rm -r Delay/
mkdir -pv Delay
cat $FILE | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' \
| sed 's/\:/ /g' > Trace_Cleaned.tr
egrep "^[sr].*AGT.*" Trace_Cleaned.tr > Trace_R_S.tr 
for conta in $(seq 0 $NODE_N); do
cat Trace_R_S.tr | awk -F" " '{   
	if($1 == "s" && $3=="'$conta'" && $4 == "AGT"){
		s_pacote[$6]=$2
		snd[$6]=$6
	}
	if($1 == "r" && $4 == "AGT"){
		r_pacote[$6]=$2
		rcv[$6]=$6
		if($6 in r_pacote && $6 in r_pacote && $6 in snd && $6 in rcv){
			delay=r_pacote[$6]-s_pacote[$6]
			printf("%3.9f\n",delay);
		}
		
	}
} ' > Delay/Delay_$conta.tr
if [ -s Delay/Delay_$conta.tr ]; then
cat Delay/Delay_$conta.tr | awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(m = 1; m <= NR; m++){
	soma = soma + Vetor_media[m]	
	}
	media = (soma/NR)
	printf("%3.9f",media)
}' > Delay/Media_Delay_$conta.tr
awk '{print}' Delay/Media_Delay_$conta.tr >> Delay/media.tr
fi
done;
cat Trace_R_S.tr | awk -F" " 'BEGIN{
count=0;
}
{   
	if($1 == "s" && $4 == "AGT"){
		s_pacote[$6]=$2
		snd[$6]=$6
	}
	if($1 == "r" && $4 == "AGT"){
		count++
		r_pacote[$6]=$2
		rcv[$6]=$6
		if($6 in r_pacote && $6 in r_pacote && $6 in snd && $6 in rcv){
			delay+=r_pacote[$6]-s_pacote[$6]
		}
	}
} END {printf("%3.9f\n",delay/count);}' > Delay/Total_Delay.tr
