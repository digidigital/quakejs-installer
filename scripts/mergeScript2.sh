#!/bin/bash
# You need to have libarchive-zip-perl installed (calculating the  crc32 checksum)
# sudo apt install libarchive-zip-perl
#
# You need to have zipmerge installed (merging the files)
# sudo apt install zipmerge

#Example: ./mergescript ../base/baseq3/pak100.pk3

file="$(basename $1)"
tempName="temp-${file}"

inputDir="./${file: -10:6}input" 

#Attempting to copy $file in the current directory...
cp $1 ./temp/$tempName

#Fix: non-pk3s cause error messages (but do not interrupt merging process)
zipmerge ./temp/$tempName $inputDir/*pk3

# Calculating CRC32 checksum... 
checksum=$((0x$(crc32 ./temp/$tempName)))

newName="$checksum-${file: -10}"
#filesize="$(stat -c%s $tempName)"
#Renaming $tempName to $newName
mv -f ./temp/$tempName ./temp/$newName
