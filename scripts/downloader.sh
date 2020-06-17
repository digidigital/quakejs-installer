#!/bin/bash
for list in ./downloadlists/*-downloads.txt
do
  fileFolder=$(basename --suffix="-downloads.txt" $list)
  wget -P "./$fileFolder/" --progress=bar -i $list
  unzip "./$fileFolder/*.[zZ][iI][pP]" "*.[pP][kK]3" -d "./$fileFolder" 
  rm -f ./$fileFolder/*.[zZ][iI][pP] 
done
