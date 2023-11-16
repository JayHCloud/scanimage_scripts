#!/bin/bash

# 3/14/2021 
# Depends on scanimage
# https://support.brother.com/g/b/faqend.aspx?c=ca&lang=en&prod=ads2000_us&faqid=faq00100611_000
# https://linux.die.net/man/1/scanimage

source secret.env # Contains file paths

#Creates unique name for each scanned document
filename=$(date '+%Y-%m-%d-%H%M%S')
dimensions='-x 210 -y 297' #A4 paper size
resolution='300'  
batchrange='--batch-start=0 --batch-count=1' 
format='--format=tiff' #Options: pnm, tiff, png, jpeg. tiff is the only option that supports multiple pages 


#Scan Command
scanimage -d 'brother4' --resolution $resolution --source 'Automatic Document Feeder(centrally aligned,Duplex)' $dimensions $format $batchrange
scanimage_pid=$!
wait $scanimage_pid
