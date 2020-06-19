#!/bin/bash 

for map in /home/quake/quakejs/customQ3maps/*pk3; do 

  # Calculating CRC32 checksum... 
  checksum=$((0x$(crc32 $map)))
  
  # Calculating filesize... 
  filesize="$(stat -c%s $map)"
  
  #Name of the map-file
  mapfile="$(basename $map)"
  
  echo "  {"
  echo "     \"name\": \"baseq3/${mapfile}\","
  echo "     \"compressed\": $filesize,"
  echo "     \"checksum\": $checksum"
  echo "  },"
  
done

