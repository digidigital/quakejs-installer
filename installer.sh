#!/bin/sh
chmod +x ./scripts/*.sh
#Read config here
source ./installerconfig.cfg

apt-get install sudo curl git nodejs npm jq apache2 wget apt-utils gosu libarchive-zip-perl zipmerge bash -y

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

useradd -ms /bin/bash "$createUser"

cd /home/$createUser/ && git clone --recurse-submodules https://github.com/begleysm/quakejs.git

cd /home/$createUser/quakejs && npm install

########################
# Content Server Setup #
########################
cp /home/$createUser/quakejs/html/* /var/www/html/

#copy html content for play page
cp ./scripts/templates/index.html /var/www/html/

#CORS htaccess + rewrite on here
a2enmod rewrite
a2enmod headers
./scripts/templates/htaccess /var/www/html/.htaccess

#funny names, random models, and server info for index.hml here 

#Get assets from quakejs-content server
./scrips/get_assets.sh /var/www/html/assets "$sourceServer"

# Not sure if we need this line since we now set fs_cdn as a parameter when starting the server... 
echo "127.0.0.1 content.quakejs.com" >> /etc/hosts

#Delete the downloaded Q3A maps? 
if [ $customMapsOnly == 1 ]
  then 
  find /var/www/html/asstes/baseq3 -type f -not -name '*pak10*' -print0 | xargs -0 -I {} rm {}
fi

#################
# Customization #
#################

cp ./scripts/templates/ioq3ded.fixed.js /home/$createUser/quakejs/build/ioq3ded.js

#Has the user defined custom downloads? 
if [ $downloadLists == 1 ]
  then 
  ./scripts/downloader.sh
fi

#Move maps to html-folder
cp ./customQ3maps/* /var/www/html/assets/baseq3


#Create autoexec.cfg and add it to pak101input
for userCFG in ./autoexec/*.cfg
do
	cat $userCFG >> ./pak101input/autoexec.cfg	
done
if [ $rconPasswordForAll == 1 ]
	then
	echo "seta rconpassword \"$rconPassword\"" >> ./pak101input/autoexec.cfg
fi	

zip ./pak101input/autoexec.pk3 ./pak101input/autoexec.cfg
rm -f ./pak101input/autoexec.cfg

#Merge baseq3 paks 100 & 101 (Directly in html-folder) (create backup for future updates)

mkdir ./paks
cp /var/www/html/asstes/baseq3/*pak10* ./paks 


# Calculate checksums and rename in baseq3 / maybe better for all folders in assets!

# create manifest.json

# restart apache service
service apache2 restart

# create baseq3 serverconfig mapcycle
#if custoMapsOnly =0 include the maps in pak0 in mapcycle

#copy serverconfigs in mod folders
for serverconfig in ./serverconfigs/*.cfg
do
        echo "seta bot_enable 1" >> $serverconfig
        echo "seta bot_minPlayers $bots" >> $serverconfig
	echo "seta cg_gibs $gore" >> $serverconfig
	echo "seta com_blood $gore" >> $serverconfig
	cp $serverconfig /home/$createUser/quakejs/base/$(basename --suffix=".cfg" $serverconfig)/serverconfig.cfg
done

chown -R $createUser:$createUser /home/$createUser/*

#create starter-script / do not forget to add fs_cdn-parameter!
