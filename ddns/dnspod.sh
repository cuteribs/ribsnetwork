#!/bin/sh

set -e

if [ $1 ]; then
	LoginToken=$1
fi

if [ $2 ]; then
	Domain=$2
fi

if [ -z "$LoginToken" -o -z "$Domain" ]; then
	echo "参数缺失"
	exit 1
fi

if [ $3 ]; then
	SubDomain=$3
fi

if [ -z "$SubDomain" ]; then
	SubDomain="@"
fi

# Get new IP address
echo "获取当前 IP..."
NewIP=$(wget -qO- --no-check-certificate http://members.3322.org/dyndns/getip)
echo "当前 IP 为 $NewIP."

# Get record ID of sub domain
echo "获取 $SubDomain.$Domain 的 IP..."
Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain" https://dnsapi.cn/Record.List)
Code=$(echo $Result | jq -r '.status.code')

if [ "$Code" = "1" ]; then
	ip=$(echo $Result | jq -r '.records[0].value')

	if [ "$ip" = "$NewIP" ]; then
		echo "IP 无变化, 退出脚本..."
		exit 0
	fi

	RecordId=$(echo $Result | jq -r '.records[0].id')
	echo "域名记录已存在, 更新 $SubDomain.$Domain 至 $NewIP..."
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&record_id=$RecordId&record_type=A&record_line_id=0&sub_domain=$SubDomain&value=$NewIP" https://dnsapi.cn/Record.Modify)
	Code=$(echo $Result | jq -r '.status.code')

	if [ "$Code" = "1" ]; then
		echo "$SubDomain.$Domain 已指向 $NewIP."
	else
		error=$(echo $Result | jq -r '.status.message')
		echo "更新失败."
		echo "错误提示: $error"
		exit 1
	fi	
else
	echo "域名记录不存在, 添加 $SubDomain.$Domain 至 $NewIP..."
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain&record_type=A&record_line_id=0&value=$NewIP" https://dnsapi.cn/Record.Create)
	Code=$(echo $Result | jq -r '.status.code')

	if [ "$Code" = "1" ]; then
		echo "$SubDomain.$Domain 已指向 $NewIP."
	else
		error=$(echo $Result | jq -r '.status.message')
		echo "添加失败."
		echo "错误提示: $error"
		exit 1
	fi	
fi
