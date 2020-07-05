#!/bin/bash 
  
  file="$1"
  currentDir="$(pwd)"

  cd "$(dirname $file)" # cd'ing into directory is necessary as workaround because of a bug in crc32 (throws an error in case you have a 8 digit checksum in the filename and use full path)  checksum=$((0x$(crc32 $file))) was so nice :( 
  # Calculating CRC32 checksum... 
  checksum=$((0x$(crc32 $(basename $file))))
  cd "$currentDir"
    
  # Calculating filesize... 
  filesize="$(stat -c%s $file)"
  
  #Name of the map-file
  filename="$(basename $file)"
  basefile="${filename##*-}"
  folders="$(dirname $file)"
  modfolder="${folders##*/}"
  
  echo "  ,{"
  echo "     \"name\": \"${modfolder}/${basefile}\","
  echo "     \"compressed\": $filesize,"
  echo "     \"checksum\": $checksum"
  echo "  }"
  

