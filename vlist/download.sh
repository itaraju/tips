#! /bin/bash

## downloading (output to stdout and out.txt)
youtube-dl --download-archive xlist-videos.txt https://www.youtube.com/playlist?list=PLQORNIsDWrwTuhZCd-oskRikcSSvY4a3i | tee /dev/tty > out.txt

echo ""
echo "out.txt created. If things sound good, it's good point to run ./download-check.sh"
