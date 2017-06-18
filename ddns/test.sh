#!/bin/sh
urlencode() {
	local raw="$1";
	local len="${#raw}"
	local encoded=""

	for i in `seq 1 $len`; do
		local j=$((i+1))
		local c=$(echo $raw | cut -c$i-$i)

		case $c in [a-zA-Z0-9.~_-]) ;;
			*)
			c=$(printf '%%%02X' "'$c") ;;
		esac

		encoded="$encoded$c"
	done

	echo $encoded
}


echo $(urlencode 'AccessKeyId=testid&Action=DescribeDomainRecords&DomainName=example.com&SignatureMethod=HMAC-SHA1&SignatureNonce=f59ed6a9-83fc-473b-9cc6-99c95df3856e&SignatureVersion=1.0&Version=2015-01-09&Timestamp=2016-03-24T16:41:54Z')