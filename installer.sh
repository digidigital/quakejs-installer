#!/bin/sh
if [ $(id -u) -ne 0 ] 
then 
	echo "Please run as root (with sudo) since we need to install some tools with apt, create a new user and adjust the files in the Apache html folder..." 
	exit 1 
fi
echo "In order to use the Q3A Demo to run your server you must agree to id Software's EULA\n\n"
cat ./idSoftwareEULA
echo ""
while : 
do
	read -p "Do you agree to the EULA? (y/n): "  agree

	case $agree in
  	  y*|Y*) break ;;
  	  n*|N*) exit 1 ;;
	esac
	
done

DIR="$(pwd)"
chmod +x ./scripts/*.sh
#Read config here
. ./installerconfig.cfg

###dpkg-lock-check loop from https://askubuntu.com/questions/132059/how-to-make-a-package-manager-wait-if-another-instance-of-apt-is-running
i=0
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    case $(($i % 4)) in
        0 ) j="-" ;;
        1 ) j="\\" ;;
        2 ) j="|" ;;
        3 ) j="/" ;;
    esac
    clear
    echo -en "[$j] Waiting for other software managers to finish..." 
    sleep 0.2
    i=$((i+1))
done 
###
apt-get install sudo curl git nodejs npm jq apache2 wget apt-utils screen libarchive-zip-perl zipmerge bash -y

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

useradd -ms /bin/bash "$createUser"

cd /home/$createUser/ && git clone --recurse-submodules https://github.com/begleysm/quakejs.git

cd $DIR
cp ./scripts/ioq3ded.fixed.js /home/$createUser/quakejs/build/ioq3ded.js

cd /home/$createUser/quakejs && npm install

########################
# Content Server Setup #
########################
cp /home/$createUser/quakejs/html/* /var/www/html/

#copy html content for play page
cd $DIR
cp -f ./scripts/templates/index.html /var/www/html/

#Customize Playpage
sed -i "s/SERVERTITLE/${serverTitle}/g" /var/www/html/index.html
sed -i "s/CONTENTSERVER/${contentServer}/g" /var/www/html/index.html
sed -i "s/SERVERIP/${serverAddress}/g" /var/www/html/index.html
sed -i "s/SERVERPORT/${serverPort}/g" /var/www/html/index.html

if [ $funnyNames = 0 ]
then
	sed -i "s/, '+name', playername//g" /var/www/html/index.html
fi

if [ $randomModels = 0 ]
then
	sed -i "s/, '+model', playermodel//g" /var/www/html/index.html
fi

#CORS htaccess + rewrite on here
a2enmod rewrite
a2enmod headers
cp -f ./scripts/templates/htaccess /var/www/html/.htaccess

#funny names, random models, and server info for index.hml here 

#Get assets from quakejs-content server
./scripts/get_assets.sh /var/www/html $sourceServer

# Not sure if we need this line since we now set fs_cdn as a parameter when starting the server... 
# echo "127.0.0.1 content.quakejs.com" >> /etc/hosts

#Delete the downloaded Q3A maps? 
if [ $customMapsOnly = 1 ]
  then 
  find /var/www/html/assets/baseq3 -type f -not -name '*pak10*' -print0 | xargs -0 -I {} rm {}
fi
nan
#################
# Customization #
#################
mkdir ./temp
#Run user defined scripts...
chmod +x ./userscripts/*
for userscript in ./userscripts/*.sh
do
	$userscript
done

#Has the user defined custom downloads? 
if [ $downloadLists = 1 ]
  then 
  ./scripts/downloader.sh
fi

#Copy maps to html-folder
cp ./customQ3maps/*.pk3 /var/www/html/assets/baseq3/

#Create autoexec.cfg and add it to pak101input
cd ./temp
mkdir ./scripts
for userCFG in ../autoexec/*.cfg
do
	cat $userCFG >> ./scripts/default.txt	
done
if [ $rconPasswordForAll = 1 ]
	then
	echo "seta rconpassword \"$rconPassword\"" >> ./scripts/default.txt
fi	

zip ../pak101input/autoexec.pk3 ./scripts/default.txt
rm -f ./scripts/*
rmdir ./scripts
cd ..

#Merge baseq3 paks 100 & 101 (Directly in html-folder) (create backup for future updates)
mkdir ./paks

cp /var/www/html/assets/baseq3/*pak10* ./paks 

./scripts/mergeScript2.sh ./paks/*pak100.pk3 
./scripts/mergeScript2.sh ./paks/*pak101.pk3 

echo "Deleting original paks in assets folder"
rm -f /var/www/html/assets/baseq3/*pak100.pk3
rm -f /var/www/html/assets/baseq3/*pak101.pk3

echo "Moving new paks to assets folder"
mv -f ./temp/*pk3 /var/www/html/assets/baseq3/ 
rm -f ./temp/*

# Calculate checksums and rename all files in the assets folders!
for folder in $(ls -d /var/www/html/assets/*/)
do
	for file in $(ls $folder*.pk3)
	do
		./scripts/crcRename.sh "$file"
	done
done

# create manifest.json
cp ./scripts/templates/manifest.json ./temp/manifest.tmp
for folder in $(ls -d /var/www/html/assets/*/)
do
	for file in $(ls $folder*.pk3)
	do
	   ./scripts/manifestor.sh "$file" >> ./temp/manifest.tmp
	done
done
echo "]" >> ./temp/manifest.tmp
mv -f ./temp/manifest.tmp /var/www/html/assets/manifest.json

# restart apache service
service apache2 restart

#Add parameters, create mapcycles and copy serverconfigs in mod folders
cp ./serverconfigs/*.cfg ./temp
for serverconfig in ./temp/*.cfg
do
        echo "seta bot_enable 1" >> $serverconfig
        echo "seta bot_minPlayers $bots" >> $serverconfig
	echo "seta cg_gibs $gore" >> $serverconfig
	echo "seta com_blood $gore" >> $serverconfig
	echo "seta rconpassword \"$rconPassword\"" >> $serverconfig
	echo "seta g_motd \"$motd\"" >> $serverconfig
	echo "seta g_gametype $gametype" >> $serverconfig
	echo "seta timelimit $timelimit" >> $serverconfig
	echo "seta fraglimit $fraglimit" >> $serverconfig
	echo "seta sv_hostname \"$hostname\"" >> $serverconfig
	echo "seta sv_maxclients $maxclients" >> $serverconfig
	# create mapcycles TODO: if custoMapsOnly =0 include the maps in pak0 in mapcycle
	./scripts/mapCycler.sh $(ls /var/www/html/assets/$(basename --suffix=".cfg" $serverconfig)/*.pk3) >> $serverconfig
	ls /home/$createUser/quakejs/base/$(basename --suffix=".cfg" $serverconfig) || mkdir /home/$createUser/quakejs/base/$(basename --suffix=".cfg" $serverconfig)
	mv -f $serverconfig /home/$createUser/quakejs/base/$(basename --suffix=".cfg" $serverconfig)/server.cfg
done

chown -R $createUser:$createUser /home/$createUser/*

#create start-script
echo "#!/bin/bash" > /home/$createUser/quakejs/startscript.sh
echo "su - quake -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $serverPort +set net_ip $serverAddress +set fs_game baseq3 +set fs_cdn '${contentServer}' +set dedicated 1 +exec server.cfg & disown\"" >> /home/$createUser/quakejs/startscript.sh

chmod +x /home/$createUser/quakejs/startscript.sh

echo "If there was no error your server should be ready ;)"
