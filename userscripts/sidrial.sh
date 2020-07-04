#!/bin/bash
# downloads installs the sidrial mod on your server
# 
#alternative download - links
#https://www.per-thormann.de/download/sidrial-v1-1/
#http://bit.ly/2E9dfIZ
#
echo "******Sidrial Total Conversion Installer******"
# ask if sidrial should be downloaded + agreee to terms and conditions
cat ./userscripts/sidrial-license.txt
while :
do
	read -p "Do you agree to this EULA? Download and install the Total Conversion? (y/n): "  agree

	case $agree in
  	  y*|Y*) break ;;
  	  n*|N*) exit 1 ;;
	esac
	
done
#download Sidrial
wget -P "./temp/" --progress=bar http://www.semaphor.eu/Sidrial_v1.1.zip

# unzip pk3's
unzip -j -d ./temp ./temp/Sidrial_v1.1.zip sidrial/*.pk3

# create assets folder on content server
mkdir /var/www/html/assets/sidrial

# move files and rename
mv -f ./temp/sidrial0.pk3 /var/www/html/assets/sidrial/pak100.pk3
mv -f ./temp/sidrial1.pk3 /var/www/html/assets/sidrial/pak101.pk3
mv -f ./temp/sidrial2.pk3 /var/www/html/assets/sidrial/pak102.pk3


# delete files in temp
rm ./temp/*

# create sidrial folder in server's base folder
mkdir /home/$1/quakejs/base/sidrial

#  # copy standard server template cfg. no mapcycle since only one mp-map is included ;)
cp ./scripts/templates/server.cfg /home/$1/quakejs/base/sidrial/sidrialserver.cfg

echo "seta bot_enable 1" >> /home/$1/quakejs/base/sidrial/sidrialserver.cfg
echo "seta bot_minPlayers 4" >> /home/$1/quakejs/base/sidrial/sidrialserver.cfg
echo 'seta rconpassword ""' >> /home/$1/quakejs/base/sidrial/sidrialserver.cfg  

# create start-script
echo "#!/bin/bash" > /home/$1/quakejs/startsidrial.sh
echo "su - $1 -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $3 +set net_ip $2 +set fs_game sidrial +set fs_cdn $4 +set dedicated 1 +map sidrialdm1 +exec sidrialserver.cfg & disown\"" >> /home/$1/quakejs/startsidrial.sh

echo "Sidrial server config location: /home/$1/quakejs/base/sidrial/sidrialserver.cfg"
echo "******Exit Sidrial Total Conversion Installer******"
