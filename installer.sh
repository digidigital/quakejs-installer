#!/bin/sh
chmod +x ./scripts/*.sh
#Read config here
source ./installerconfig.cfg

apt-get install sudo curl git nodejs npm jq apache2 wget apt-utils gosu libarchive-zip-perl zipmerge bash -y

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

useradd -ms /bin/bash "$createUser"

cd /home/$createUser/ && git clone --recurse-submodules https://github.com/begleysm/quakejs.git

cp ./scripts/ioq3ded.fixed.js /home/$createUser/quakejs/build/ioq3ded.js

cd /home/$createUser/quakejs && npm install

########################
# Content Server Setup #
########################
cp /home/$createUser/quakejs/html/* /var/www/html/

#copy html content for play page
cp ./scripts/templates/index.html /var/www/html/

#####TODO######
#Customize Playpage
###########################################################################

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

#Has the user defined custom downloads? 
if [ $downloadLists == 1 ]
  then 
  ./scripts/downloader.sh
fi

#Copy maps to html-folder
cp ./customQ3maps/*.pk3 /var/www/html/assets/baseq3/


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
mkdir ./temp
cp /var/www/html/asstes/baseq3/*pak10* ./paks 

./scripts/mergeScript2.sh ./paks/*pak100.pk3 
./scripts/mergeScript2.sh ./paks/*pak101.pk3 

echo "Deleting original paks in assets folder"
rm -f /var/www/html/assets/baseq3/*pak100.pk3
rm -f /var/www/html/assets/baseq3/*pak101.pk3

echo "Moving new paks to assets folder"
mv -f ./temp/*pk3 /var/www/html/assets/baseq3/ 
rm -f ./temp/*

# Calculate checksums and rename all files in the asssets folders!
for folder in $(ls -d /var/www/html/assets/*/)
do
	./scripts/crcRename.sh "/var/www/html/assets/$folder/*.pk3"
done

# create manifest.json
cp ./scripts/templates/manifest.json ./temp/manifest.tmp
for folder in $(ls -d /var/www/html/assets/*/)
do
	for file in $(ls -d "/var/www/html/assets/$folder/.pk3")
	do
	   ./scripts/manifestor.sh "$file" >> ./temp/manifest.tmp
	done
done
echo "]" >> ./temp/manifest.tmp
mv -f ./temp/manifest.tmp /var/www/html/assets/manifest.json

# restart apache service
service apache2 restart

#Add parameters, create mapcycles and copy serverconfigs in mod folders
for serverconfig in ./serverconfigs/*.cfg
do
        echo "seta bot_enable 1" >> $serverconfig
        echo "seta bot_minPlayers $bots" >> $serverconfig
	echo "seta cg_gibs $gore" >> $serverconfig
	echo "seta com_blood $gore" >> $serverconfig
	echo "seta rconpassword \"$rconPassword\"" >> $serverconfig
	# create mapcycles TODO: if custoMapsOnly =0 include the maps in pak0 in mapcycle
	./scripts/mapCycler.sh /var/www/html/assets/$(basename --suffix=".cfg" $serverconfig)/*.pk3 >> $serverconfig
	cp $serverconfig /home/$createUser/quakejs/base/$(basename --suffix=".cfg" $serverconfig)/server.cfg
done

chown -R $createUser:$createUser /home/$createUser/*

#create start-script
echo "#!/bin/bash" > /home/$createUser/quakejs/startscript.sh
echo "node build/ioq3ded.js +set fs_game baseq3 +set fs_cdn '${contentServer}' +set dedicated 1 +exec server.cfg & disown" >> > /home/$createUser/quakejs/startscript.sh
chmod +x /home/$createUser/quakejs/startscript.sh
