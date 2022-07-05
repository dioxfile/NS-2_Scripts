#!/bin/bash
rm Convert-Node.sh -v
TRACE="$1" H_FIRST="$2" H_LAST="$3" N_FIRST="$4" N_LAST="$5"
if [ -z "$TRACE" ]; then
  echo "USAGE: ./Hierarchical_to_Node_Converter.sh <FILE.tr> <H_FIRST> <H_LAST> <N_FIRST> <N_LAST>"
  exit 1
fi

if [ -z "$H_FIRST" ]; then
  echo "USAGE: ./Hierarchical_to_Node_Converter.sh <FILE.tr> <H_FIRST> <H_LAST> <N_FIRST> <N_LAST>"
  exit 1
fi

if [ -z "$H_LAST" ]; then
  echo "USAGE: ./Hierarchical_to_Node_Converter.sh <FILE.tr> <H_FIRST> <H_LAST> <N_FIRST> <N_LAST>"
  exit 1
fi

if [ -z "$N_FIRST" ]; then
  echo "USAGE: ./Hierarchical_to_Node_Converter.sh <FILE.tr> <H_FIRST> <H_LAST> <N_FIRST> <N_LAST>"
  exit 1
fi
if [ -z "$N_LAST" ]; then
   echo "USAGE: ./Hierarchical_to_Node_Converter.sh <FILE.tr> <H_FIRST> <H_LAST> <N_FIRST> <N_LAST>"
  exit 1
fi

#### Clears the trace
echo "Cleanning Trace..."
cat $TRACE | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' | sed 's/\:/ /g' > TRACE_CLEAN.tr
ha=$((H_FIRST+0))
Stringval=" "
for ((i=$N_FIRST; i<=$N_LAST; i++)); do
if [ $ha -le `expr $H_LAST + 1` ]; then
    if [ $i = $N_FIRST ]; then
        Stringval+="cat TRACE_CLEAN.tr | sed 's/$ha/$i/g' |"  
    elif [ $i == $N_LAST ]; then  
        Stringval+=" sed 's/$ha/$i/g' > TRACE_NODE_CONVERTED.tr"
    else
        Stringval+=" sed 's/$ha/$i/g' |"
    fi
    ha=$((ha+1))
fi
done
echo "#!/bin/bash" > Convert-Node.sh  
echo $Stringval >> Convert-Node.sh 
chmod +x Convert-Node.sh
./Convert-Node.sh
