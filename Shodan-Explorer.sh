#!/bin/bash
# Author G0ble

#Colours
grC="\e[0;32m\033[1m" #greenColour
eC="\033[0m\e[0m" #endColour
rC="\e[0;31m\033[1m" #redColour
bC="\e[0;34m\033[1m" #blueColour
yC="\e[0;33m\033[1m" #yellowColour
pC="\e[0;35m\033[1m" #purpleColour
tC="\e[0;36m\033[1m" #turquoiseColour
gC="\e[0;37m\033[1m" #greyColour

#Ctrl_C
trap ctrl_c INT
function ctrl_c(){
    echo -e "\n\n${rC}[!] Exiting...${eC}\n"
    tput cnorm; exit 1
}

#Help Panel
function helpPanel(){
	echo -e "\n${yC}[!]${eC}${gC} Use: ./Shodan-Explorer.sh${eC}\n"
	echo -e "\t${pC}-q: ${eC}${yC}Search query${eC}"
	echo -e "\t${pC}-l: ${eC}${yC}Limit of results${eC}"
	echo -e "\t${pC}-f: ${eC}${yC}File name${eC}\n"
	exit 0
}

#Banner
function Banner(){
	clear
	printf ${rC}
	figlet -w 100 Shodan Explorer
}

#Shodan Search
function startSearch(){
	echo -e "\n${yC}[*]${eC}${gC} This script uses Shodan.io to analize IoT devices.${eC}"

	shodan download --limit $limit $fichero $query &> /dev/null
	filtrado=$(shodan parse --fields ip_str,port,org --separator , $fichero.json.gz 2>&1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u)
	echo -e "\n${yC}[*]${eC}${gC} $fichero.txt has been created.${eC}"
	echo "$filtrado" > $fichero.txt
	rm $fichero.json.gz
	sleep 3
	
	echo -e "\n${yC}[*]${eC}${gC} Analysing the state of the devices: ${eC}\n"
	sleep 2
	
	echo -e "\t${pC}Ip:             State:${eC}"
	sleep 2

	file="${fichero}.txt"
	ips=$(cat $file)
	touch filtered.txt

	COUNTER=0
	for ip in $ips; do
	    timeout 1 bash -c "ping -c 1 $ip > /dev/null 2>&1" && echo -e "\t${yC}-${eC}${tC}$ip${eC} - ACTIVE" && echo "$ip" >> filtered.txt &
	    let COUNTER++
	done; wait

	rm $fichero.txt
	mv filtered.txt $fichero.txt
	echo -e "\n${yC}[*]${eC}${gC} Finished! We found $COUNTER active devices.${eC}\n"
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
	Banner
	startSearch
	tput cnorm
fi
