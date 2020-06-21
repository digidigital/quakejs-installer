#!/bin/bash 
  
  file=$1

  # Calculating CRC32 checksum... 
  checksum=$((0x$(crc32 $file)))
  
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
  

