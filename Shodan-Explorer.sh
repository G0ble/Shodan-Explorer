#!/bin/bash
# Author G0ble

#Colours
gC="\e[0;32m\033[1m" #greenColour
eC="\033[0m\e[0m" #endColour
rC="\e[0;31m\033[1m" #redColour
bC="\e[0;34m\033[1m" #blueColour
yC="\e[0;33m\033[1m" #yellowColour
pC="\e[0;35m\033[1m" #purpleColour
tC="\e[0;36m\033[1m" #turquoiseColour
gC="\e[0;37m\033[1m" #greyColour

#Ctrl_C
trap ctrl+c INT

function ctrl_c(){
	echo -e "\n\n${rC}[!] Saliendo...${eC}\n"
	exit 1
}

function helpPanel(){
	echo -e "\n${yC}[!]${eC}${gC} Modo de uso: ./Shodan-Explorer.sh${eC}\n"
	echo -e "\t${pC}-q: ${eC}${yC}Consulta de búsqueda${eC}"
	echo -e "\t${pC}-l: ${eC}${yC}Número de resultados obtenidos${eC}"
	echo -e "\t${pC}-f: ${eC}${yC}Nombre del fichero${eC}\n"
	exit 0
}

function startSearch(){
	echo -e "\n${gC}[*] Esta herramienta pretende automatizar el descubrimiento de dispositivos mediante el uso de Shodan.io${eC}"

	shodan download --limit $limit $fichero $query &> /dev/null
	filtrado=$(shodan parse --fields ip_str,port,org --separator , $fichero.json.gz 2>&1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u)
	echo -e "\n${gC}[*] Se ha creado el fichero $fichero.txt con los resultados de la búsqueda.${eC}"
	echo "$filtrado" > $fichero.txt
	rm $fichero.json.gz
	sleep 5

	echo -e "\n${gC}[*] Analizando el estado de las máquinas: ${eC}\n"
	sleep 5
	echo -e "\t${pC}Ip:            Estado:${eC}"
	sleep 4

	file="${fichero}.txt"
	ips=$(cat $file)
	COUNTER=0

	for ip in $ips; do
	    timeout 1 bash -c "ping -c 1 $ip > /dev/null 2>&1" && echo -e "\t${yC}-${eC}${tC}$ip${eC} - ACTIVE" &
	    let COUNTER++
	done; wait

	echo -e "\n${gC}[*] Análisis finalizado. Se encuentran $COUNTER máquinas activas.${eC}\n"
	sleep 8
}

#Main Function

declare -i parameter_counter=0; while getopts ":q:f:l:h:" arg; do
	case $arg in
		q) query=$OPTARG; let parameter_counter+=1 ;;
		f) fichero=$OPTARG; let parameter_counter+=1 ;;
		l) limit=$OPTARG; let parameter_counter+=1 ;;
		h) helpPanel ;;
	esac
done

if [ $parameter_counter -ne 3 ]; then
	helpPanel
else
	startSearch
fi

