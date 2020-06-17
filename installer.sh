#!/bin/sh
chmod +x ./scripts/*.sh
#Read config here

#Create user here

#Install basic stuff here

#copy html content for play page
rm /var/www/html/index.html

#CORS htaccess + rewrite on here

#funny names, random models, and server info for index.hml here 

#Get assets from quakejs-content server
./scrips/get_assets.sh /var/www/html/assets "$sourceServer"

#Delete the downloaded Q3A maps? 
if [ $customMapsOnly == 1 ]
  then 
  find /var/www/html/asstes/baseq3 -type f -not -name '*pak10*' -print0 | xargs -0 -I {} rm {}
fi

#Has the user defined custom downloads? 
if [ $downloadLists == 1 ]
  then 
  ./scripts/downloader.sh
fi

#Move maps to html-folder
cp ./customQ3maps/* /var/www/html/assets/baseq3

#Merge baseq3 paks 100 & 101 (Directly in html-folder) (create backup for future updates)
mkdir ./paks
cp /var/www/html/asstes/baseq3/*pak10* ./paks 

# Calculate checksums and rename in baseq3 / maybe better for all folders in assets!

# create manifest.json

# restart apache service
service apache2 restart

# start / kill quakejs in order to download content to server

# create baseq3 serverconfig mapcycle
#if custoMapsOnly =0 include the maps in pak0 in mapcycle

#copy serverconfigs in mod folders
for serverconfig in ./serverconfigs/*.cfg
do
	cp $serverconfig /home/$createUser/quakejs/base/$(basename --suffix=".cfg" $serverconfig)/serverconfig.cfg
done



#create starter-script / do not forget to add fs_cdn-parameter!
