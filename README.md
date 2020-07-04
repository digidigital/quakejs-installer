# quakejs-installer
The goal of this project is to make installing your own quakejs-server easy :)

Feature list:
* Installs all necessary tools
* Creates a separate user
* Many settings can be adjusted by simply applying changes to a config file
* Adds the BFG10, grenade launcher and replaces the machine gun
* Adds random 'funny' player names
* Adds random player model selection
* Replaces the broken wearoff sound with silence 
* Simply drop your custom maps and additional assets in folders
* Checksums get calculated automatically
* Mapcycles will be genererated and added to server.cfg-files automatically
* Support for automated downloads of ZIPed maps and other assets
* Customize the default key bindings and add your own config files
* Alternative download script in case content.quakejs.com is down and you can't download the Q3A demo files (userscripts folder)
* Comes with scripts to install Instagib, CrateDM, CZ45qomical, CZ45q3agm2019 and Sidrial mods (userscripts folder) in addition to CPMA

## Quick-Start
Install git
```
sudo apt-get install git
```

To install the server locally (127.0.0.1) simply clone this repository with:
```
git clone https://github.com/digidigital/quakejs-installer.git
```

cd into the cloned repository: 
```
cd ./quakejs-installer
```

Run the installer:
```
sudo ./installer.sh
```

Start your server:
```
cd /home/quake/quakejs/ 
sudo ./startscript.sh
```

DONE! Open a supported browser and open http://127.0.0.1

Stop your server:
```
cd /home/quake/quakejs/ 
sudo ./stopscript.sh
```

## Customize your server
If you have followed the steps above you have created a very basic Q3A-Server. Before you run the installer you can easily customize your server by changing the settings in the installerconfig.cfg, by simply dropping files in the appropriate folders or even preparing URL-lists with ZIP-files (e. g. containing maps, skins or texture packs) that are automatically downloaded for you.

### installerconfig.cfg
First you should open the *installerconfig.cfg* and change the settings as needed. 
```
nano ./installerconfig.cfg
```

### How to add maps
Just put the map .pk3-file in the *customQ3maps* folder. The maps will be installed in the *baseq3* folder. If your map comes with a separate .pk3-file for additional assets (music, models or textures) merge the pk3-files or put the additional files in the *pak100input* or *pak101input* folders.  

### How to add models, skins, sounds, texture packs 
Put the pk3-files in *pak100input* or *pak101input* folders. Size seems to be limited. If pak100 or pak101 are not loaded by the browser you can try to remove some files from the input folders. In general it is a good idea to add missing textures only instead of using a complete texture pack (e.g. high-res). Smaller files speed up loading times. This can improve the user experiece over Wifi networks or when the user has a slow internet connection.  

An example for custom sounds are the qualityannouncer sounds that are played when you press 'h'. They have been zipped to the qualityannouncer.pk3-file that is located in the *pak101input* folder and are referenced in the qualitytoggle.cfg in the *autoexec* folder.

### Adjust default key-bindings
Apply your changes to the cfg-files in the *autoexec* folder. You can add your own scripts as well. The installer merges all the scripts into one large script. It will be executed when the player joins your server.

### Automatic downloads
You can add URLs to the files in the *downloadlists* folder. One URL in each line. It is important that the pk3-files are int he top level of the ZIP-file. In the case of maps only ZIP-files that contain map-pk3-files are supported (Otherwise the additional pk3s are treated as maps and will be added to the mapcycle). 

### User defined scripts
Add your own .sh-scripts to the *userscripts* folder. They will be executed after the base installation is complete and the assets have been downloaded from content.quakejs.com
- Set userscripts=1 in installerconfig.cfg to activate the userscripts feature
- Only files with the extension *.sh* will be treated as scripts.

### How to add mods
You need to write a script in order to install mods. Just use the examples in the *userscripts* folder as templates. 

The basic steps are:
* (optional) Download mod
* Extract the pk3-files
* Create a mod folder for the content server */var/www/html/assets/modname*
* Copy the pk3-files in the newly created folder and rename them pak100.pk3, pak101.pk3, pak102.pk3 (and so on)
* (optional) Copy additional key bindings and client scripts in the *autoexec* folder (file extension cfg)
* Create a start scipt for the server and add config parameters to the command line with "+set valuename value"
* (optional) If the server config has too many parameters you can create a separate configuration file. Create it in /home/\<yournewuser\>/quakejs/base/\<modname\> (e.g. /home/quake/quakejs/base/sidrial). Add "+exec <nameofconfigfile>.cfg" to the parameters in the start script (example in *cratemod.sh*) 
* (optional) Maps for your mods should be copied to */var/www/html/assets/modname*. Naming convention: \<mapname\>.pk3 
* (optional) In case you see a lot of missing textures and you do not want to add them to the base game paks simply put them in a separate pak and put them in the mod folder of the content server (example in *cratemod.sh*) 

### Start server after reboot
Simply put the startscript in the root crontab. It will start the server with the quake user.
```
sudo crontab -e
```
add this line
```
@reboot  /home/quake/quakejs/startscript.sh
```
### server.cfg
If you want change setting in your server.cfg after the game was installed just open the file and apply the changes...
```
nano  /home/quake/quakejs/base/baseq3/server.cfg
```
## Things that can be improved

* Add a script (or parameter) to to update configuration, maps and mapcycle without the need to run setup from scratch 
* Add the Q3A-Demo maps in pak0.pk3 to the automatically created mapcycle 
* ~~Create start-scripts for mod-folders~~ Done!
* ~~Create a stop-script~~ Done!
* ~~User defined scripts~~ Done!
* ~~Add support for mods~~ Done!

## Security concerns / Disclaimer

* The scripts is executed with root privileges and will download and install files from various souces that are not under my control.
* Nodejs warns you that parts of quakeJS contain security issues.

Therefore you should not run this script on a production machine, a company network or a public webserver if you don't exactly know what you are doing!  

## Troubleshooting tips / known issues

* In case content.quakejs.com is down and you can't download the demo files just rename the *alternativeDownload.sh.example* in the *userscripts* folder so it has the file extension *.sh* In *installerconfig.cfg* set *userscripts=1*
*  If you have alot of missing textures press "l" (small L) and check the console for textures that are labelled as 'DEFAULTED' Just create a .pk3 with the missing textures (take them from e.g. openarena and preserve the paths when zipping e.g. /textures/base_trim/texturename.tga) and put the *.pk3* in *pk101input* folder. Creating a .pk3-file is easy - it is just a zip-file with the file extension *.zip* changed to *.pk3*

## Thanks ;)

A big thanks goes to 

@inolen -> https://github.com/inolen/quakejs for starting quakejs

@begleysm -> https://github.com/begleysm/quakejs for his great tutorials

@treyyoder -> https://github.com/treyyoder/quakejs-docker for the "fix" in ioq3ded.js and the idea to automate the install process

@Grabisoft -> https://github.com/grabisoft for his tutorial on how to manipulate the pk3s

This installer is inspired and based on their work, research and motivation to keep quakejs alive ;)
