#!/bin/bash 
echo "Creating temporary manifest"
cp ./manifest.json ./manifest.tmp
echo "Creating temporary server.cfg"
cp ./server.cfg ./server.tmp

echo "Merging additional content into *pak100.pk3 and *pak101.pk3 in /var/www/html/assets/baseq3"
./mergescript2 /var/www/html/assets/baseq3/*pak100.pk3 >> ./manifest.tmp
./mergescript2 /var/www/html/assets/baseq3/*pak101.pk3 >> ./manifest.tmp

# Todo: mergescript2 
# Calculate checksum and rename files
# Output manifest.json info

echo "Deleting original paks in assets folder"
rm -f /var/www/html/assets/baseq3/*pak100.pk3
rm -f /var/www/html/assets/baseq3/*pak101.pk3

echo "Moving new paks to assets folder"
mv -f ./*pk3 /var/www/html/assets/baseq3/ 

echo "Calculating checksums for maps and adding info to manifest.json" 
./map-manifestor >> ./manifest.tmp

echo "Adding new mapcycle to temporary server.cfg"
./map-cycler >> ./server.tmp

echo "Renaming the maps with crc-rename"
./crc-rename /home/quake/quakejs/customQ3maps/*

echo "Moving maps to /var/www/html/assets/baseq3"
mv -f /home/quake/quakejs/customQ3maps/* /var/www/html/assets/baseq3/ 

echo "Moving server.cfg to /home/quake/quakejs/base/baseq3/server.cfg"
mv -f ./server.tmp /home/quake/quakejs/base/baseq3/server.cfg

echo "Copying footer with CPMA-info to temporary manifest.json"
cat ./manifest.footer >> ./manifest.tmp

echo "Moving temporary manifest.json to /var/www/html/assets to replace original manifest"
mv -f ./manifest.tmp /var/www/html/assets/manifest.json

echo "MISSION COMPLETE! 411 Y0UR B453 4R3 B310N9 70 U5!!!"
