#!/bin/bash
# Installs the EP mod on your server :)
echo "******Excessive+ Installer******"

# unzip mod and move file to assets folder of content server
unzip -d ./temp ./mods/xp-2.3.zip

rm ./temp/*bat

mkdir /var/www/html/assets/excessiveplus

mv -f ./temp/excessiveplus/z-xp-2_0a.pk3 /var/www/html/assets/excessiveplus/pak100.pk3 
mv -f ./temp/excessiveplus/z-xp-2_1.pk3 /var/www/html/assets/excessiveplus/pak101.pk3 
mv -f ./temp/excessiveplus/z-xp-2_2b.pk3 /var/www/html/assets/excessiveplus/pak102.pk3 
mv -f ./temp/excessiveplus/z-xp-2_3.pk3 /var/www/html/assets/excessiveplus/pak103.pk3 
chmod +r /var/www/html/assets/excessiveplus/*

#move mod folder in game server's base directory  
mv -f ./temp/excessiveplus /home/$1/quakejs/base/
mv -f /home/$1/quakejs/base/excessiveplus/server.cfg /home/$1/quakejs/base/excessiveplus/epserver.cfg

# create start-script
echo "#!/bin/bash" > /home/$1/quakejs/startep.sh
echo "su - $1 -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $3 +set net_ip $2 +set fs_game excessiveplus +set fs_cdn $4 +set dedicated 1 +exec epserver.cfg & disown\"" >> /home/$1/quakejs/startep.sh

chmod +x /home/$1/quakejs/startep.sh
echo "Change server settings by altering the config files in /home/$1/quakejs/base/excessiveplus/"
echo "******Exit Excessive+ Installer******"
