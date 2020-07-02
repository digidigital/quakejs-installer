#!/bin/bash
# downloads installs the True Combat mod on your server

echo "******True Combat Mod (Q3TC045) Installer******"
# ask if mod should be downloaded + agreee to terms and conditions
do
	read -p "Download and install external file? (y/n): "  agree

	case $agree in
  	  y*|Y*) break ;;
  	  n*|N*) exit 1 ;;
	esac
	
done
#download True combat
wget -P "./temp/" --progress=bar http://tce.merlin1991.at/tc/q3tc0.45b12beta.zip

# unzip pk3s
unzip -d ./temp ./temp/q3tc0.45b12beta.zip q3tc045/*3

# unzip cfg
unzip -d ./temp ./temp/q3tc0.45b12beta.zip q3tc045/q3tc_server.cfg

# create assets folder on content server
mkdir /var/www/html/assets/q3tc045

# move files and rename
mv -f ./temp/pak0.PK3 /var/www/html/assets/q3tc045/pak100.pk3
mv -f ./temp/pak1.pk3 /var/www/html/assets/q3tc045/pak101.pk3
mv -f ./temp/pak2.pk3 /var/www/html/assets/q3tc045/pak102.pk3
mv -f ./temp/pak3.pk3 /var/www/html/assets/q3tc045/pak103.pk3
mv -f ./temp/pak4.pk3 /var/www/html/assets/q3tc045/pak104.pk3
mv -f ./temp/pak5.pk3 /var/www/html/assets/q3tc045/pak105.pk3
mv -f ./temp/pak6.pk3 /var/www/html/assets/q3tc045/pak106.pk3

# create tc folder in server's base folder
mkdir /home/$1/quakejs/base/q3tc045

# move tc server cfg
mv -f ./temp/q3tc_server.cfg /home/$1/quakejs/base/q3tc045/

# delete files in temp
rm ./temp/*

# create start-script
echo "#!/bin/bash" > /home/$1/quakejs/startq3tc.sh
echo "su - $1 -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $3 +set net_ip $2 +set fs_game q3tc045 +set fs_cdn $4 +set dedicated 1 +exec q3tc_server.cfg & disown\"" >> /home/$1/quakejs/startq3tc.sh

