Script per creare una rete nintendo homepass per openwrt<br><br>
Fornire i permessi di esecuzione al file "homepass.sh"<br>
$ chmod +x homepass.sh<br>
spostare i file "homepass.sh" e homepass.list nella cartella "/etc"<br>
$ mv homepass.* /etc<br>
creare il cron per l'esecuzione automatica dello script<br>
$ crontab -e<br>
*/2 *  *   *   *  /etc/homepass.sh 2>&1 >> /tmp/homepass.log<br>
0 */8 *   *   *  echo "$(date): Log truncated." > /tmp/homepass.log<br><b>

P.S.: La rete wifi deve già essere attiva e configurata con SSID: NZ@McD1