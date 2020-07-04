#!/bin/bash
# Installs the 24h mod on your server :)
echo "******24h mod Installer******"

# unzip mod and move file to assets folder of content server
unzip -j -d ./temp ./mods/24h_mod_danewone_v1.4.zip 24h-mod/*.pk3

mkdir /var/www/html/assets/24h-mod

mv -f ./temp/pak0.pk3 /var/www/html/assets/24h-mod/pak100.pk3 
mv -f ./temp/pak1.pk3 /var/www/html/assets/24h-mod/pak101.pk3 
mv -f ./temp/pak2.pk3 /var/www/html/assets/24h-mod/pak102.pk3 
mv -f ./temp/pak3.pk3 /var/www/html/assets/24h-mod/pak103.pk3 
mv -f ./temp/pak4.pk3 /var/www/html/assets/24h-mod/pak104.pk3 

rm ./temp/*

# create mod folder in game server's base directory  
mkdir /home/$1/quakejs/base/24h-mod

# copy basic config template to the server's mod folder
cp ./scripts/templates/server.cfg /home/$1/quakejs/base/24h-mod/24hserver.cfg

# add mapcycle

echo 'set g_gametype 0' >> /home/$1/quakejs/base/24h-mod/24hserver.cfg
echo 'set m1 "fraglimit 10 ; map 24h-map1 ; set nextmap vstr m2"' >> /home/$1/quakejs/base/24h-mod/24hserver.cfg
echo 'set m2 "fraglimit 10 ; map 24h-map2 ; set nextmap vstr m3"' >> /home/$1/quakejs/base/24h-mod/24hserver.cfg
echo 'set m3 "fraglimit 15 ; map 24h-map3 ; set nextmap vstr m4"' >> /home/$1/quakejs/base/24h-mod/24hserver.cfg
echo 'set m4 "fraglimit 10 ; map 24h-map4 ; set nextmap vstr m5"' >> /home/$1/quakejs/base/24h-mod/24hserver.cfg
echo 'set m5 "fraglimit 15 ; map 24h-map5 ; set nextmap vstr m6"' >> /home/$1/quakejs/base/24h-mod/24hserver.cfg
echo 'set m6 "fraglimit 15 ; map 24h-map6 ; set nextmap vstr m7"' >> /home/$1/quakejs/base/24h-mod/24hserver.cfg
echo 'set m7 "fraglimit 15 ; map 24h-map7 ; set nextmap vstr m8"' >> /home/$1/quakejs/base/24h-mod/24hserver.cfg
echo 'set m8 "fraglimit 10 ; map 24h-map8 ; set nextmap vstr m1"' >> /home/$1/quakejs/base/24h-mod/24hserver.cfg
echo 'vstr m1' >> /home/$1/quakejs/base/cratedm3/24hserver.cfg

# create start-script
echo "#!/bin/bash" > /home/$1/quakejs/start24hmod.sh
echo "su - $1 -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $3 +set net_ip $2 +set fs_game 24h-mod +set fs_cdn $4 +set dedicated 1 +exec 24hserver.cfg & disown\"" >> /home/$1/quakejs/start24hmod.sh

chmod +x /home/$1/quakejs/start24hmod.sh

echo "******Exit 24h mod Installer******"
