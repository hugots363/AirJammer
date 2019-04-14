# bssids=( $(cut -d ' ' -f1 res.txt) ) #empieza titulo en 0
# channel=( $(cut -d ' ' -f3 res.txt) ) #en 0
# power=( $(cut -d ' ' -f5 res.txt) ) #en 0
# essids=( $(cut -d ' ' -f7 res.txt) ) #en 0

#eligiendo red para atacar por el user
# for ((i=0; i < ${#essids[@]}; i++))
# do
# 	echo -ne "$i) ${essids[$i]}  ${bssids[$i+1]} ${power[$i]} ${channel[$i]}"| column -t 

# 	#echo '[${essids[$i]}]' '[${bssids[$i+1]}]' '[${power[$i]}]' '[${channel[$i]}]'
# done

#NO SE COMO PONERLO EN COLUMNAS
# column "{essids[@]}" "${bssids[@]}" "${power[@]}"

# for ((i=0; i < ${#essids[@]}; i++))
#     do
#             printf "%15s  %15s  %15s\n" "{essids[$i]}" "${bssids[$i+1]}" "${power[$i]}"
#     done


# pr -3 -tx <<eof
# ${essids[@]}
# ${power[@]}
# ${channel[@]}
# eof
# for ((i=0; i < ${#essids[@]}; i++))
# do
# 	#echo -ne "$i) ${essids[$i]}  ${bssids[$i+1]} ${power[$i]} ${channel[$i]}"| column -t 

# 	echo '['${essids[$i]}']' '['${bssids[$i+1]}']' '['${power[$i]}']' '['${channel[$i]}']'
# done
# column -c 20 <<eof
# ${essids[@]}
# ${power[@]}
# ${channel[@]}
# eof
#awk '{print ((NR-1)%3)+1, $0}' $1 > res.txt
awk '{if (NR!=1) {print}}' output_red-01.csv
awk '{print NR  ") " $s}' output_red-01.csv > output_red-01.csv

echo "Introduce el numero de la red a atacar:"
read $num

