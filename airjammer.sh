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
echo "Introduce el numero de una interfaz de red de las listadas para realizar el ataque con ella"
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


sudo iwconfig ${interfaces[$select]} mode monitor
echo "Matando los pocesos que puedan interferir con el ataque"
sleep 1.5s
sudo airmon-ng check kill

#Listando las redes en alcance
#sudo airodump-ng ${interfaces[$select]}
rm output_red-01.csv
sudo airodump-ng -w output_red --output-format csv ${interfaces[$select]}
#genera un archivo con las columnas BSSID,channel, intensidad y ESSID
awk -F "\"*,\"*" '{print $1,$4,$9,$14}' output_red-01.csv > res.txt

#essids=(); bssids=(); channels=(); power=() son los arrays con datos
bssids=( $(cut -d ' ' -f1 res.txt) ) #empieza titulo en 0
channel=( $(cut -d ' ' -f3 res.txt) ) #en 0
power=( $(cut -d ' ' -f5 res.txt) ) #en 0
essids=( $(cut -d ' ' -f7 res.txt) ) #en 0


# PARTE DE PRINTEAR NUMERADAS LAS REDES -- REVISAR TODO- -- MUERTE Y DESTRUCCION
#eliminar primera linea csv
awk '{if (NR!=1) {print}}' output_red-01.csv
#numerar el CSV por lineas
awk '{print NR  ") " $s}' output_red-01.csv 
#rm output_red-01.csv
#eligiendo red para atacar por el user
echo "Introduce el numero de la red a atacar"


#LIMPIAR AL SALIR!
