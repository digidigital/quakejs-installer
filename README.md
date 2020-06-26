# quakejs-installer (all padman edition)
The goal of this project is to make installing your own quakejs-server easy :)

Feature list:
* Preconfigured to download (almost) all available padmaps & padmodels (padgarden and padgallery have two versions that can't be installed at once since the .bsps replace each other) 
* Installs all necessary tools
* Creates a separate user
* Many settings can be adjusted by simply applying changes to a config file
* Adds the BFG10, grenade launcher and replaces the machine gun
* Adds random 'funny' pad names
* Adds random pad model selection
* Replaces the broken wearoff sound with silence 
* Simply drop pk3s of your custom maps and additional assets in folders
* Checksums get calculated automatically
* Mapcycles will be genererated and added to server.cfg-files automatically
* Support for automated downloads of ZIPed maps and other assets
* Customize the default key bindings and add your own config files

## Quick-Start
Install git
```
sudo apt-get install git
```

To install the server locally (127.0.0.1) simply clone this repository with:
```
git clone --single-branch --branch all-padman-edition https://github.com/digidigital/quakejs-installer.git
```

cd into the cloned repository: 
```
cd ./quakejs
```

Make the installer scripts executable:
```
chmod +x inst*
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
Stop your server:
```
cd /home/quake/quakejs/ 
sudo ./stopscript.sh
```
DONE! Open a supported browser and open http://127.0.0.1

## Customize your server
If you have followed the steps above you have created a very basic Q3A-Server. Before you run the installer you can easily customize your server by changing the settings in the installerconfig.cfg, by simply dropping files in the appropriate folders or even preparing URL-lists with ZIP-files (e. g. containing maps, skins or texture packs) that are automatically downloaded for you.

### installerconfig.cfg
First you should open the *installerconfig.cfg* and change the settings as needed. 
```
nano ./installerconfig.sh
```
* You should replace 127.0.0.1 with the IP or name of your comupter (or domainname)!
* Set a RCON-Password!

### How to add maps
Just put the map .pk3-file in the *customQ3maps* folder. If your map comes with a separate .pk3-file for additional assets (music, models or textures) merge the pk3-files or put the additional files in the *pak100input* or *pak101input* folders.  

### How to add models, skins, sounds, texture packs 
Put the pk3-files in *pak100input* or *pak101input* folders. Size is limited. If pak100 or pak101 are not loaded by the browser you can try to remove some files from the input folders. In general it is a good idea to add missing textures only instead of using a complete texture pack (e.g. high-res). Smaller files speed up loading times. This can improve the user experiece over Wifi networks or when the user has a slow internet connection.  

An example for custom sounds are the qualityannouncer sounds that are played when you press 'h'. They have been zipped to the qualityannouncer.pk3-file that is located in the *pak101input* folder and are referenced in the qualitytoggle.cfg in the *autoexec* folder.

### Adjust default key-bindings
Apply your changes to the cfg-files in the *autoexec* folder. You can add your own scripts as well. The installer merges all the scripts into one large script. It will be executed when the player joins your server.

### Automatic downloads
You can add URLs to the files in the *downloadlists* folder. One URL in each line. It is important that the pk3-files are int he top level of the ZIP-file. In the case of maps only ZIP-files that contain map-pk3-files are supported (Otherwise the additional pk3s are treated as maps and will be added to the mapcycle). 

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
* Create start-scripts for mod-folders 
* Add support for mods (maybe... QuakeJS.com runs TF so that might work)

## Troubleshooting tips / known issues

* Security - The quakeJS-nodeJS code is old and seems to have some vulnerabilities. Run this over the internet at your own risk! 

## Thanks ;)

A big thanks goes to 

@inolen -> https://github.com/inolen/quakejs for starting quakejs

@begleysm -> https://github.com/begleysm/quakejs for his great tutorials

@treyyoder -> https://github.com/treyyoder/quakejs-docker for the "fix" in ioq3ded.js and the idea to automate the install process

@Grabisoft -> https://github.com/grabisoft for his tutorial on how to manipulate the pk3s

Andreas Endres (ENTE) -> https://worldofpadman.net/ for creating world of padman :)

This installer is inspired and based on their work, research and motivation to keep quakejs alive ;)
