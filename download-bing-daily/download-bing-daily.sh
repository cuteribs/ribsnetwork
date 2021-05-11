#!/bin/sh

FOLDER="."

if [ $1 ]; then
        FOLDER=$1
fi

URL_BASE="https://cn.bing.com"
URL="${URL_BASE}/HPImageArchive.aspx?format=xml&idx=0&n=1&uhd=1&uhdwidth=3840&uhdheight=2592"
XML=$(curl -s $URL)
IMG_URL_BASE=$(echo $XML | xmllint --xpath '/images/image[1]/urlBase/node()' -)
IMG_URL_SUFFIX="_UHD.jpg&w=3840&h=2592&rs=1&c=1&pid=hp"
IMG_URL="${URL_BASE}${IMG_URL_BASE}${IMG_URL_SUFFIX}"
FILE_NAME=$(echo $XML | xmllint --xpath '/images/image[1]/startdate/node()' -)

curl $IMG_URL -s -o "${FOLDER}/${FILE_NAME}.jpg"
