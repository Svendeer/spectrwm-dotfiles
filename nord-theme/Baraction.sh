#!/bin/env bash
# Pequeño script para la barra de estado
Time(){
    time=$(date +'%H:%M')
    echo "  $time "
}

Date(){
	date=$(date +'%a/%d/%b')
	echo "  $date "
}

Volume(){
	VOL=$(pamixer --get-volume)
	echo "  $VOL% "
}

Brightness(){
	echo "  $(light)% "
}

Memory(){
    RAM=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
	echo "  $RAM"
}

Network(){
    read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
	if iwconfig $int1 >/dev/null 2>&1; then
	    wifi=$int1
	    eth0=$int2
	else 
	    wifi=$int2
	    eth0=$int1
	fi

    ip link show $eth0 | grep 'state UP' >/dev/null && int=$eth0 || int=$wifi

    echo -n "  $int"

    ping -c1 -s1 8.8.8.8 >/dev/null 2>&1 && echo " Conectado." || echo "Desconectado."
}

while :; do
    echo "+@fg=4;+@fg=2;+@bg=1;$(Time)+@fg=5;+@fg=2;+@bg=2;$(Date)+@fg=6;+@fg=2;+@bg=3;$(Volume)+@fg=7;+@fg=2;+@bg=4;$(Brightness)+@fg=8;+@fg=2;+@bg=5;$(Memory)+@fg=9;+@fg=2;+@bg=6;$(Network)+@fg=3;+@fg=0;+@bg=0;"
	sleep 0.1
done
