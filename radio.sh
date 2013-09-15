#!/bin/bash
# Una radio para escuchar online las noticias de meneame
#

#Directorio donde tenemos los mp3 de nuestras canciones favoritas
RUTA_MUSICA=/home/pi/Documents/Musica/

# Funcion que ejecuta una cancion aleatoria cada vez
function cancion() {
a=($RUTA_MUSICA*); mpg123 "${a[$((RANDOM % ${#a[@]}))]}"
}

# Funcion para evitarnos tener que decir sleep
function duerme() {
sleep 1
}

# Funcion para, dependiendo de la hora, saludar
function hora() {
hour=`date +%k`
if [ $hour -gt 15 ]; then
   echo -e "Buenas tardes\c"

elif [ $hour -gt 21 ]; then
echo -e "Buenas noches\c"

elif [ $hour -gt 05 ]; then
   echo -e "Buenos dias\c"
fi
}

######################################################################################
# Comenzamos con un corto saludo y la primera cancion
######################################################################################

clear
hora | iconv -f utf-8 -t iso-8859-1|festival --tts
echo "empezamos en tres, dos, uno" | iconv -f utf-8 -t iso-8859-1|festival --tts  
cancion

# Saludamos y lanzamos eltiempo.sh para que nos diga el tiempo de Benicassim
echo -e '\E[1;33;44m'""
hora | iconv -f utf-8 -t iso-8859-1|festival --tts
echo -e " a toda nuestra audiencia, \c" | iconv -f utf-8 -t iso-8859-1|festival --tts 

./eltiempo.sh "EUR|Spain|12560|Benicasim"; tput sgr0; echo ""; 
./eltiempo.sh "EUR|Spain|12560|Benicasim" > /tmp/eltiempo.txt
cat /tmp/eltiempo.txt | festival --tts; 

NUM=0

while [ $NUM -le 10 ]; do
   echo "Vamos a leer las ultimas noticias PUBLICADAS en portada" | iconv -f utf-8 -t iso-8859-1|festival --tts
   echo -e "Vamos a leer las ultimas noticias PUBLICADAS en portada\n"
   duerme
   curl -s http://meneame.feedsportal.com/rss|sed 's/</\n/g'|grep 'title>'|sed -e '/^\// d' -e 's/title>/ /g'| grep -v 'publicadas'|head -n 6 | iconv -f utf-8 -t iso-8859-1;

   curl -s http://meneame.feedsportal.com/rss|sed 's/</\n/g'|grep 'title>'|sed -e '/^\// d' -e 's/title>/ /g' | grep -v 'publicadas' | head -n 6 | iconv -f utf-8 -t iso-8859-1 > /tmp/resultado_curl.txt

   while read line; do echo -e "$line\n" | festival --tts; sleep 1; done < /tmp/resultado_curl.txt

   duerme
   echo -e "\nA continuacion, vamos a leer las ultimas noticias EN COLA de meneame.net \n"
   echo "A continuacion, vamos a leer las ultimas noticias EN COLA de meneame.net" | iconv -f utf-8 -t iso-8859-1|festival --tts
   curl -s http://www.meneame.net/rss2.php?status=queued|sed 's/</\n/g'|grep 'title>'|sed -e '/^\// d' -e 's/title>/ /g' | grep -v 'en cola' | head -n 6 | iconv -f utf-8 -t iso-8859-1;

   curl -s http://www.meneame.net/rss2.php?status=queued|sed 's/</\n/g'|grep 'title>'|sed -e '/^\// d' -e 's/title>/ /g' | grep -v 'en cola' | head -n 6 | iconv -f utf-8 -t iso-8859-1 > /tmp/resultado2_curl.txt

   while read line; do echo -e "$line\n" | festival --tts; sleep 1; done < /tmp/resultado2_curl.txt

   echo "Seguiremos leyendo mas tarde" | iconv -f utf-8 -t iso-8859-1 | festival --tts;
   echo -e "\nSeguiremos leyendo mas tarde" | iconv -f utf-8 -t iso-8859-1;
   echo "Ahora vamos a poner algo de musica" | iconv -f utf-8 -t iso-8859-1 | festival --tts;
   echo -e "Ahora vamos a poner algo de musica.\n" | iconv -f utf-8 -t iso-8859-1;
   duerme
   let NUM=$NUM+1
   cancion
   cancion
   cancion
   cancion
   duerme
   clear
done

