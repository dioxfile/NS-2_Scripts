#!/bin/dash
FILE="$1"
NODE="$2"
if [ -z "$FILE" ]; then
  echo "USAGE: ./calc_energy.sh <FILE.tr> <NODE_N>"
  exit 1
fi
if [ -z "$NODE" ]; then  
  echo "USAGE: ./calc_energy.sh <FILE.tr> <NODE_N>"
  exit 1
fi
NODE_N=`expr $NODE - 1`
rm -r Energy/
mkdir -pv Energy
cat $FILE | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' \
| sed 's/\:/ /g' > Trace_Cleaned.tr
for conta in $(seq 0 $NODE_N); do
egrep "^[sr].*" Trace_Cleaned.tr | awk -F" " '{\
if($3=="'$conta'"){{print $14 }}}' > Energy/Energia_All_by_$conta.e
cat Energy/Energia_All_by_$conta.e | awk 'END{ print 100-$1 }' > \
Energy/E_Consumption_by_Node_$conta.e
cat Energy/E_Consumption_by_Node_$conta.e >> Energy/Average_Node.e   
done;
cat Energy/Average_Node.e | awk '{
Vetor_media[NR] = $0
} END {
	for(m = 0; m <= NR; m++){
	soma = soma + Vetor_media[m]	
	}
		media = (soma/NR)
		printf("%3.9f",media)
}' > Energy/Energy_Average.tr
