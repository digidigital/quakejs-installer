#!/bin/bash
# Install the qomical mod on your server
echo "******CZ45's gameplay mod pack (2019) Installer******"
# unzip mod and move file to assets folder of content server
unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/pakcz00*
unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/pakcz01*
unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/pakcz03*

echo "*********Gib & Blood Effects*********"
echo "1 -> ReadyPlayerOne(film) style coins effect." # "pakcz04coins.pk3"
echo "2 -> Over-the-top emulation of the CoD4 style blood spurt effects." # "pakcz04blood.pk3" 
echo "3 -> Quake 3, with a little bit of a certain popular videogame's aestethics." # "pakcz04emcee.pk3" 
echo "4 -> An explosive theme." # "pakcz04firefx.pk3" 
echo "5 -> Serious Sam-inspired hippie aestethic." # "pakcz04flowers.pk3" 
echo "6 -> Theme of choice for those who want to let it go." # "pakcz04frosten.pk3"
echo "7 -> Absolute cancer." # "pakcz04maymays.pk3" 
echo "8 -> what? You never played Quake 3?..." # "pakcz04pyuds.pk3" 
echo "9 -> Turn every gladiatiors into plasma goo." # "pakcz04plasma.pk3" 
echo "10 -> For those who wants a proper broken fighting game feel." # "pakcz04rainbowedition.pk3" 
echo "11 -> Quake 3 like it's the 80's!" # "pakcz04retro.pk3" 
echo ""
read -p "Choose a gib/blood effect by entering it's number: "  effect

case $effect in
  1)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04coins.pk3
  ;;
  2)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04blood.pk3
  ;;
  3)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04emcee.pk3
  ;;
  4)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04firefx.pk3
  ;;
  5)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04flowers.pk3
  ;;
  6)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04frosten.pk3
  ;;
  7)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04maymays.pk3
  ;;
  8)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04pyuds.pk3
  ;;
  9)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04plasma.pk3
  ;;
  10)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04rainbowedition.pk3
  ;;
  11)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04retro.pk3
  ;;
  *)
    unzip -j -d ./temp ./mods/cz45q3agm2019.zip cz45q3agm/themepaks/pakcz04emcee.pk3
  ;;
 
esac

mkdir /var/www/html/assets/cz45q3agm

mv -f ./temp/pakcz00* /var/www/html/assets/cz45q3agm/pak100.pk3
mv -f ./temp/pakcz01* /var/www/html/assets/cz45q3agm/pak101.pk3
mv -f ./temp/pakcz03* /var/www/html/assets/cz45q3agm/pak102.pk3
mv -f ./temp/pakcz04* /var/www/html/assets/cz45q3agm/pak103.pk3
chmod +r /var/www/html/assets/cz45q3agm/* 

# create start-script
echo "#!/bin/bash" > /home/$1/quakejs/startcz45q3agm.sh
echo "su - $1 -c \"cd ~/quakejs && node build/ioq3ded.js +set net_port $3 +set net_ip $2 +set fs_game cz45q3agm +set fs_cdn $4 +set r_railCoreWidth 13 +set cg_shadows 1 +set r_railWidth 8 +set dedicated 1 +set r_ignorehwgamma 1 +set cg_oldRail 1 +set cg_oldPlasma 1 +set cg_oldRocket 1 +set cg_draw3dicons 0 +set cg_oldRail 1 +set cg_truelightning 1 +exec server.cfg & disown\"" >> /home/$1/quakejs/startcz45q3agm.sh

chmod +x /home/$1/quakejs/startcz45q3agm.sh

echo "******Exit CZ45's gameplay mod pack (2019) Installer******"
