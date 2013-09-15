#!/bin/sh
# Script que busca y muestra la temperatura en la consola desde
# los RSS de la web de AccuWeather
#
# (c) Michael Seiler 2007
#
# Visto en https://bbs.archlinux.org/viewtopic.php?id=37381
# Modificaciones Joan Catala <joan@riseup.net> 2013
#

out=`curl --connect-timeout 30 -s http://rss.accuweather.com/rss/liveweather_rss.asp\?metric\=1\&locCode\=$1 | perl -ne 'if (/Currently/) {chomp;/\<title\>Currently: (.*)?\<\/title\>/; print "$1"; }'`

cond=`echo $out | cut -d':' -f 1`
temperatura=`echo $out | cut -d':' -f 2`

# Empezamos la frase
echo "hoy tenemos un dia \c" 

# Traduccion al castellano de los resultados
case "$cond" in

'Fog')
    echo "con niebla \c"
;;
'Snow')
    echo "nevado \c"
;;
'Cloudy')
    echo "nublado \c"
;;
'Sunny')
   echo -"totalmente soleado \c"
;;
'Partly Sunny')
   echo "parcialmente soleado \c"
;;
'Mostly Sunny')
   echo "bastante soleado \c"
;;
'Mostly Clear')
   echo "practicamente sin nubes \c"
;;
'T-Storms')
   echo "con probables tormentas \c"
;;
'Intermittent Clouds')
   echo "con nubes intermitentes \c"
;;
*)
   echo -e  $cond'\c'
esac

# Ahora le decimos la temperatura resultante de la web
echo "y aproximadamente con una temperatura de \c"
echo $temperatura

# FIN de eltiempo.sh
