#!/bin/bash

# 8/20/2020 Rev3
# Depends on brscan-skey, libtiff-tools, scanimage
# https://support.brother.com/g/b/faqend.aspx?c=ca&lang=en&prod=ads2000_us&faqid=faq00100611_000
# https://linux.die.net/man/1/scanimage

source secret.env # Contains file paths

dimensions='-x 210 -y 297' #A4 paper size
resolution='300'  
batchrange='--batch-start=0 --batch-count='$batchmax
batchmax='20' #Seperated for loop use
format='--format=tiff' #Options: pnm, tiff, png, jpeg. tiff is the only option that supports multiple pages 

#Scan Command
scanimage -d 'brother4' --resolution $resolution --source 'Automatic Document Feeder(centrally aligned,Duplex)' $dimensions $format $batchrange
scanimage_pid=$!
wait $scanimage_pid

#filenames default to outX.tiff, where X is the file number
#uses tiffcp to combine the two pages into one file
for (( i=0; i<=$batchmax; i+=2))
do 

 filename=$(date '+%Y%m%d%H%M%S%3N') 
 
 if [ -e "out$i.tif" ] && [ -e "out$((i + 1)).tif" ]; then   #tiffcp will create blank files if the source doesnt exist
   tiffcp out$i.tif out$((i + 1)).tif $filename.tiff #combines index and index +1 (front and back)
   tiffcp_pid=$!
   wait $tiffcp_pid  
   
 else
 
   echo "Page does not exist, skipping"
 
 fi
 
done


#removes original files
rm out*.tif

#Moves file to paperless storage folder
mv "$filename"*.tiff $paperless