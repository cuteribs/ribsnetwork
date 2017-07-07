#!/bin/sh

/ss/obfs-server -s 0.0.0.0 -p 8139 --obfs $Obfs -r $ServerPort &
/ss/ss-server -s 0.0.0.0 -p $ServerPort -m $Method -k $Password -u