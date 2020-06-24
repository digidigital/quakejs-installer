# quakejs-installer
The goal of this project is to make installing your own quakejs-server easy :)

Feature list:
* Installs all necessary tools
* Creates a separate user
* Many settings can be adjusted by simply applying changes to a config file
* Drop your maps and additional assets in folders
* Checksums get calculated automatically
* Mapcycles will be genererated and added to server.cfg-files automatically
* Support for automated downloads of ZIPed maps and other assets
* Customize the default key bindings and add your own scripts

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

DONE! Open a supported browser and open http://127.0.0.1

## Customize your server
If you have followed the steps above you have created a very basic Q3A-Server. Before opyu run the installer you can easily customize your server by changing the settings in the installerconfig.cfg, simply dropping files in the appropriate folders or even preparing URL-lists with ZIP-files (e. g. containing maps, skins or texture packs) that are automatically downloaded for you.

### installerconfig.cfg
First you should open the *installerconfig.cfg* and change the settings as needed. 
```
nano ./installerconfig.sh
```

### How to add maps
Just put the map .pk3-file in the *customQ3maps* folder. If your map comes with a separate .pk3-file for additional assets (music, models or textures) merge the pk3-files or put the additional files in the *pak100input* or *pak101input* folders.  

### How to add models, skins, sounds, texture packs 
Put the pk3-files in *pak100input* or *pak101input* folders. Size is limited. If pak100 or pak101 are not loaded by the browser you can try to remove some files from the input folders. 

### Adjust default key-bindings
Apply your changes to the cfg-files in the *autoexec* folder. You can add your own scripts as well. The installer merges all the scripts into one large script. It will be executed when the player joins your server.

### Automatic downloads
You can add URLs to the files in the *downloadlists* folder. One URL in each line. It is important that the pk3-files are int he top level of the ZIP-file. In the case of maps only ZIP-files that contain map-pk3-files are supported (Otherwise the additional pk3s are treated as maps and will be added to the mapcycle). 

## Things that can be improved

* Add a script to to update configuration, maps and mapcycle without the need to run setup from scratch 
* Add the Q3A-Demo maps to the mapcycle 
* Create start-scripts for mod-folders
* Create a stop-script

## Thanks ;)

A big thanks goes to 

@inolen -> https://github.com/inolen/quakejs

@begleysm -> https://github.com/begleysm/quakejs

@treyyoder -> https://github.com/treyyoder/quakejs-docker

@Grabisoft -> https://github.com/grabisoft
This installer is inspired and based on their work, research and willingness to keep quakejs alive ;)
