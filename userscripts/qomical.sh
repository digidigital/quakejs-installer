
#!/bin/bash
# Install the qomical mod on your server
echo "******qomical mod Installer******"
# unzip mod and move file to assets folder of content server
unzip -j -d ./temp ./mods/cz45qomical.zip qomical/*.pk3

mkdir /var/www/html/assets/qomical

mv -f ./temp/zpakqt.pk3 /var/www/html/assets/qomical/pak100.pk3
mv -f ./temp/zztoonskins.pk3 /var/www/html/assets/qomical/pak101.pk3
chmod +r /var/www/html/assets/qomical/* 

# create start-script
echo "#!/bin/bash" > /home/$1/quakejs/startqomical.sh
echo "su - $1 -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $3 +set net_ip $2 +set fs_game qomical +set fs_cdn $4 +set r_railCoreWidth 13 +set cg_shadows 1 +set r_railWidth 8 +set dedicated 1 +set r_ignorehwgamma 1 +set cg_oldRail 1 +set cg_oldPlasma 1 +set cg_oldRocket 1 +set cg_draw3dicons 0 +set cg_oldRail 1 +set cg_truelightning 1 +exec server.cfg & disown\"" >> /home/$1/quakejs/startqomical.sh

chmod +x /home/$1/quakejs/startqomical.sh

echo "******Exit qomical Installer******"
