#!/bin/bash
# downloads installs the TrueCombat mod on your server
# 
echo "******TrueCombat Installer******"

#download TC
wget -P "./mods/" --progress=bar http://tce.merlin1991.at/tc/TrueCombat11Full.zip

# unzip pk3's
unzip -j -d ./temp ./mods/TrueCombat11Full.zip truecombat/*.pk3

# create assets folder on content server
mkdir /var/www/html/assets/truecombat

# move files and rename
mv -f ./temp/pak0.pk3 /var/www/html/assets/truecombat/pak100.pk3
mv -f ./temp/pak1.pk3 /var/www/html/assets/truecombat/pak101.pk3
mv -f ./temp/pak2.pk3 /var/www/html/assets/truecombat/pak102.pk3
mv -f ./temp/map_pak0.pk3 /var/www/html/assets/truecombat/pak103.pk3
mv -f ./temp/map_pak1.pk3 /var/www/html/assets/truecombat/pak104.pk3

chmod +r /var/www/html/assets/truecombat/*
# delete files in temp
rm ./temp/*

# create tc folder in server's base folder
mkdir /home/$1/quakejs/base/truecombat

# copy server cfgs and mapcycle to server base folder
unzip -j -d /home/$1/quakejs/base/truecombat ./mods/TrueCombat11Full.zip/truecombat/*.cfg

#  copy server cfg.cp ./userscripts/tcserver.cfg /home/$1/quakejs/base/truecombat/

# create start-script
echo "#!/bin/bash" > /home/$1/quakejs/starttc.sh
echo "su - $1 -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $3 +set net_ip $2 +set fs_game truecombat +set fs_cdn $4 +set dedicated 1 +exec tcserver.cfg & disown\"" >> /home/$1/quakejs/starttc.sh

chmod +x home/$1/quakejs/starttc.sh
echo "TrueCombat server config location: /home/$1/quakejs/base/truecombat/tcserver.cfg"
echo "******Exit TrueCombat Installer******"
