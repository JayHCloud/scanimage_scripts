#!/bin/bash

# 8/16/2020 Rev1
# Depends on brscan-skey, scanimage
# https://support.brother.com/g/b/faqend.aspx?c=ca&lang=en&prod=ads2000_us&faqid=faq00100611_000
# https://linux.die.net/man/1/scanimage

source secret.env # Contains file paths

#Creates unique name for each scanned document
filename=$(date '+%Y-%m-%d-%H%M%S')
dimensions='-x 210 -y 297' #A4 paper size
resolution='4800'  #Options: 100|150|200|300|400|600|1200|2400|4800|9600dpi [200]
batchrange='--batch-start=0 --batch-count=1'
format='--format=png' #Options: pnm, tiff, png, jpeg


#Scan Command
scanimage -d 'brother4' --resolution $resolution --source 'Automatic Document Feeder(centrally aligned,Duplex)' $dimensions $format $batchrange
scanimage_pid=$!
wait $scanimage_pid

#Moves file to paperless storage folder
mv "$filename"*.tiff $paperless