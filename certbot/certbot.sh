#!/bin/sh

if [ $1 ]; then
	DomainList=$1
fi

if [ $2 ]; then
	Email=$2
fi

if [ $3 ]; then
	LoginToken=$3
fi

DomainListParameters=''

for i in $(echo $DomainList | tr "," "\n")
do 
	DomainListParameters="$DomainListParameters -d $i"
done

certbot certonly -n -c cli.ini -m $Email --manual-auth-hook /certbot/dnspod-auth-hook.sh $DomainListParameters
