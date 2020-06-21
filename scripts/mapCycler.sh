#!/bin/bash
echo "//Mapcycle automatically created by install.sh / map-cycler during installation"

#Read directory customQ3maps in an Array
mapfile=""

declare -a FILELIST
for file in "$@"; do 
   mapfile="$(basename "$file" .pk3)"
   mapfile="${mapfile##*-}"
   if [ "$mapfile" != "pak100" ] && [ "$mapfile" != "pak101" ] # ignore pak-files
   then
      FILELIST=("${FILELIST[@]}" "$mapfile")
   fi
done

#Create mapcycle
vstr=1
nextvstr=1

#Loop over items and create mapcycle lines
for mapname in ${"FILELIST[@]"}
do
  
  if [ $vstr -eq ${#FILELIST[@]} ] 
   then   
      nextvstr=1  
   else
      let "nextvstr=vstr+1"  
   fi  

   echo "set d${vstr} \"map ${mapname}; set nextmap vstr d${nextvstr}\""
   let "vstr++"
done

echo "vstr d1"
