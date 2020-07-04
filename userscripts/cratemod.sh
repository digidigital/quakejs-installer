#!/bin/bash
# Installs the crate mod on your server :)
echo "******Cratemod Installer******"

# unzip mod and move file to assets folder of content server
unzip -j -d ./temp ./mods/cratedm3_v1.0.zip cratedm3/pak0.pk3

mkdir /var/www/html/assets/cratedm3

mv -f ./temp/pak0.pk3 /var/www/html/assets/cratedm3/pak100.pk3 
cp ./mods/cratemodtextures.zip /var/www/html/assets/cratedm3/pak101.pk3

rm ./temp/*
# create mod folder in game server's base directory  
mkdir /home/$1/quakejs/base/cratedm3

# copy basic config template to the server's mod folder
cp ./scripts/templates/server.cfg /home/$1/quakejs/base/cratedm3/crateserver.cfg

# add mapcycle
echo 'set d1 "map cratedm3_dm1 ; set nextmap vstr d2"' >> /home/$1/quakejs/base/cratedm3/crateserver.cfg
echo 'set d2 "map cratedm3_dm2 ; set nextmap vstr d1"' >> /home/$1/quakejs/base/cratedm3/crateserver.cfg
echo 'vstr d1' >> /home/$1/quakejs/base/cratedm3/crateserver.cfg

# create start-script
echo "#!/bin/bash" > /home/$1/quakejs/startcratemod.sh
echo "su - $1 -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $3 +set net_ip $2 +set fs_game cratedm3 +set fs_cdn $4 +set dedicated 1 +exec crateserver.cfg & disown\"" >> /home/$1/quakejs/startcratemod.sh

chmod +x /home/$1/quakejs/startcratemod.sh

echo "******Exit Cratemod Installer******"
