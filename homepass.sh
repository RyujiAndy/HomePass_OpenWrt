#!/bin/sh

DEFAULT_SSID="NZ@McD1"

DATE=$(date)

WIFI=$(uci show wireless | grep "mode='ap'" | awk 'NR>1{print $1}' RS=[ FS=] | head -n 1)

if [ ! -s /etc/homepass.list ]; then
  echo "elenco di indirizzi MAC e' mancante o pari a zero di lunghezza."
  exit
fi

LENGTH=$(wc -l < /etc/homepass.list)

if [ -z "$WIFI" ]; then
  echo "Impossibile identificare la configurazione Wi-Fi per la rete Nintendo Zone!"
  echo "si prega di aver configurato un punto di accesso Wi-Fi Nintendo Zone ((ssid $DEFAULT_SSID) prima di eseguire questo script."
  exit
fi

if [ -z "$1" ]; then
   I=$(uci get wireless.@wifi-iface[$((WIFI))].profile)
   if [ -z "$I" ]; then
      I=1
   else
     I=$((I+1))
   fi
   if [ $I -gt $LENGTH ]; then
      I=1
   fi
else
   I=$1
fi

MAC=$(sed -n $((I))p /etc/homepass.list | awk '{print $1}' FS="\t")
if [ -n "$MAC" ]; then
   SSID=$(sed -n $((I))p /etc/homepass.list | awk '{print $2}' FS="\t")
   if [ -n "$SSID" ]; then
      echo "$DATE: Impostazioni profilo $I. Trovato nella lista ssid $SSID per mac $MAC"
   else
      SSID="$DEFAULT_SSID"
      echo "$DATE: Impostazioni profilo $I. Trovato nella lista ssid $SSID per mac $MAC"
   fi
   uci set wireless.@wifi-iface[$((WIFI))].profile=$I
   uci set wireless.@wifi-iface[$((WIFI))].macaddr=$MAC
   uci set wireless.@wifi-iface[$((WIFI))].ssid="$SSID"
   wifi
else
   echo "Abbiamo avuto un problema nella lettura dell'indirizzo MAC dall'elenco, abortire."
fi
