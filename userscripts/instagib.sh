#!/bin/bash
# Install the instagib mod on your server
echo "******Instagib Installer******"
# unzip mod and move file to assets folder of content server
unzip -d ./temp ./mods/InstaGib129.zip InstaGib129.pk3

mkdir /var/www/html/assets/InstaGib129

mv -f ./temp/InstaGib129.pk3 /var/www/html/assets/InstaGib129/pak100.pk3 
chmod +r /var/www/html/assets/InstaGib129/pak100.pk3 

# create start-script
echo "#!/bin/bash" > /home/$1/quakejs/startinstagib.sh
echo "su - $1 -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $3 +set net_ip $2 +set fs_game InstaGib129 +set fs_cdn $4 +set dedicated 1 +exec server.cfg & disown\"" >> /home/$1/quakejs/startinstagib.sh

chmod +x /home/$1/quakejs/startinstagib.sh

echo "******Exit Instagib Installer******"
