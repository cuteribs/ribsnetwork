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

# Get new IP address
echo "获取当前 IP..."
NewIP=$(wget -qO- --no-check-certificate http://members.3322.org/dyndns/getip)
echo "当前 IP 为 $NewIP."

# Get record ID of sub domain
echo "获取 $SubDomain.$Domain 的 IP..."
Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain" https://dnsapi.cn/Record.List)
Code=$(echo $Result | sed 's/.*:{"code":"\([0-9]*\)".*/\1/')

if [ "$Code" = "1" ]; then
	ip=$(echo $Result | sed 's/.*\,"value":"\([0-9\.]*\)".*/\1/')

	if [ "$ip" = "$NewIP" ]; then
		echo "IP 无变化, 退出脚本..."
		exit 0
	fi

	RecordId=$(echo $Result | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
	echo "域名记录已存在, 更新 $SubDomain.$Domain 至 $NewIP..."
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&record_id=$RecordId&record_type=A&record_line_id=0&sub_domain=$SubDomain&value=$NewIP" https://dnsapi.cn/Record.Modify)
	Code=$(echo $Result | sed 's/.*:{"code":"\([0-9]*\)".*/\1/')

	if [ "$Code" = "1" ]; then
		echo "$SubDomain.$Domain 已指向 $NewIP."
	else
		echo "更新失败."
		echo $Result
		exit 1
	fi	
else
	echo "域名记录不存在, 添加 $SubDomain.$Domain 至 $NewIP..."
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain&record_type=A&record_line_id=0&value=$NewIP" https://dnsapi.cn/Record.Create)
	Code=$(echo $Result | sed 's/.*:{"code":"\([0-9]*\)".*/\1/')

	if [ "$Code" = "1" ]; then
		echo "$SubDomain.$Domain 已指向 $NewIP."
	else
		echo "添加失败."
		echo $Result
		exit 1
	fi	
fi
