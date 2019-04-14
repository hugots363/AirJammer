#!/bin/bash
# CIRIDAE 

echo "Script AirJammer by Ciridae"
echo "¿Tienes el paquete aircrack-ng? [Y/n]"
read var1 
tput cuu1; tput el #borrar ultima linea del bash
if [ "$var1" = "y" -o "$var1" = "Y"  ]; then 
	echo "Lo tienes instalado"
	sleep 2s
	clear
else
	echo "." ;  sleep 0.5s
	tput cuu1; tput el
	echo ".."; sleep 0.5s
	tput cuu1; tput el
	echo "..."; sleep 0.5s
	echo "Este script necesita tenerlo instalado, saliendo"
fi

