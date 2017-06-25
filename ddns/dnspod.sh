#!/bin/sh

set -e

if [ $1 ]; then
	ApiId=$1
fi

if [ $2 ]; then
	ApiKey=$2
fi

if [ $3 ]; then
	Domain=$3
fi

if [ -z "$ApiId" -o -z "$ApiKey" -o -z "$Domain" ]; then
	echo "参数缺失"
	exit 1
fi

if [ $4 ]; then
	SubDomain=$4
fi

if [ -z "$SubDomain" ]; then
	SubDomain="@"
fi

LoginToken="$ApiId,$ApiKey"

sendRequest() {
	local result=$(wget -qO- --no-check-certificate --content-on-error --post-data "$2" https://dnsapi.cn/$1)
	echo $result
}

getRecordId() {
	echo "获取 $SubDomain.$Domain 的 IP..." >&2
	local queryString="login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain"
	local result=$(sendRequest "Record.List" "$queryString")
	local code=$(echo $result | sed 's/.*:{"code":"\([0-9]*\)".*/\1/')

	if [ "$code" = "1" ]; then
		ip=$(echo $result | sed 's/.*\,"value":"\([0-9\.]*\)".*/\1/')

		if [ "$ip" = "$NewIP" ]; then
			echo "IP 无变化, 退出脚本..." >&2
			echo "quit"
		else
			local recordId=$(echo $result | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
			echo $recordId
		fi
	else
		echo "null"
	fi
}

# $1 = record ID, $2 = new IP
updateRecord() {
	local queryString="login_token=$LoginToken&format=json&domain=$Domain&record_id=$1&record_type=A&record_line_id=0&sub_domain=$SubDomain&value=$2"
	local result=$(sendRequest "Record.Modify" $queryString)
	local code=$(echo $result | sed 's/.*:{"code":"\([0-9]*\)".*/\1/')

	if [ "$code" = "1" ]; then
		echo "$SubDomain.$Domain 已指向 $2." >&2
	else
		echo "更新失败." >&2
		echo $result >&2
	fi
}

# $1 = new IP
addRecord() {
	local queryString="login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain&record_type=A&record_line_id=0&value=$1"
	local result=$(sendRequest "Record.Create" $queryString)
	local code=$(echo $result | sed 's/.*:{"code":"\([0-9]*\)".*/\1/')

	if [ "$code" = "1" ]; then
		echo "$SubDomain.$Domain 已指向 $1." >&2
	else
		echo "添加失败." >&2
		echo $result >&2
	fi
}

# Get new IP address
echo "获取当前 IP..."
NewIP=$(wget -qO- --no-check-certificate http://members.3322.org/dyndns/getip)
echo "当前 IP 为 $NewIP."

# Get record ID of sub domain
recordId=$(getRecordId)

if [ ! "$recordId" = "quit" ]; then
	if [ "$recordId" = "null" ]; then
		echo "域名记录不存在, 添加 $SubDomain.$Domain 至 $NewIP..."
		addRecord $NewIP
	else
		echo "域名记录已存在, 更新 $SubDomain.$Domain 至 $NewIP..."
		updateRecord $recordId $NewIP
	fi
fi