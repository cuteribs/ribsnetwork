#!/bin/sh

/ss/obfs-local -s $Server -p 8139 --obfs $Obfs -r $ServerPort &
/ss/ss-local -s 0.0.0.0 -p $ServerPort -m $Method -k $Password -u