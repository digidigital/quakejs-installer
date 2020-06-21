# quakejs-installer
The goal of this project is to make installing your own quakejs-server easy :)

## Quick-Start
To install the server locally (127.0.0.1) simply clone this repository with:
'''
git clone https://github.com/digidigital/quakejs-installer.git
'''

cd into the cloned repository: 
'''
cd ./quakejs
'''

Make the installer scripts executable:
'''
chmod +x inst*
'''

Run the installer:
'''
sudo ./installer.sh
'''

Start your server:
'''
cd /home/quake/quakejs/ && ./startscript.sh
'''

DONE! Open a supported browser and open http://127.0.0.1

## Customize your server
If you have followed the steps above you have created a very basic Q3A-Server. The installer enables you to easily customize your server by changing the settings in the installerconfig.cfg, simply dropping files in the appropriate folders or even preparing UTL-lists with ZIP-files that are automatically downloaded for you.

### installerconfig.cfg
ToDo

### How to add maps
ToDo

### How to add models, skins, texture packs 
ToDo

### Adjust default key-bindings
ToDo

## Things that can be improved

* Add a script to to update configuration, maps and mapcycle without the need to run setup from scratch 
* Add the Q3A-Demo maps to the mapcycle 
