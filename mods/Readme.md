I am not sure if mods are properly supported. Simple ones (with one pk100.pk3??) may work.
The basic idea is to create sub-folders for each mod. The installer copies the folders to 
the content server and updates the manifest. 

You can create a serverconfig for the mod in the serverconfigs folder. 
Name it *modfoldername*.cfg so the installer is able to copy it int the right mod-folder.
It will be renamed to serverconfig.cfg

Mods that you usually put into the baseq3-folder (e.g. weapon replacements) should go into 
pak100input or pak101input folders instead.
