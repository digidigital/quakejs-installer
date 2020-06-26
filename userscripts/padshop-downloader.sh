#!/bin/bash
wget -P "./temp/" --progress=bar https://worldofpadman.net/files/q3map-padshop.zip
  unzip "./temp/q3map-padshop.zip" "padshop.pk3" -d "./customQ3maps"
  unzip "./temp/q3map-padshop.zip" "padshop_music.pk3" -d "./pak101input"
  rm -f ./temp/q3map-padshop.zip 
