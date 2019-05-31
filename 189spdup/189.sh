#!/usr/sh

CONNECTION_TIME="15"
TRANSMISSION_TIME="15"

formatHeaderString() {
    OLD_IFS=$IFS
    IFS="$1"
    STR="$2"
    ARRAY=(${STR})
    for i in "${!ARRAY[@]}"
    do
        HEADERS="$HEADERS -H '${ARRAY[$i]}'"
    done
    echo ${HEADERS} | sed 's/^ //'
    IFS=${OLD_IFS}
}

get() {
    HEADER="$1"
    URL="$2"
    eval curl -s --connect-timeout "${CONNECTION_TIME}"  -m "${TRANSMISSION_TIME}" "${HEADER}" "${URL}"
}

post() {
    HEADER="$1"
    URL="$2"
    PAYLOAD="$3"
    eval curl -s --connect-timeout "${CONNECTION_TIME}" -m "${TRANSMISSION_TIME}" -X POST "${URL}" "${HEADER}" -w %{http_code} -d "'$PAYLOAD'"
}

hashHmac() {
    digest="$1"
    data="$2"
    key="$3"
    echo -n "$data" | openssl dgst "-$digest" -hmac "$key" | sed -e 's/^.* //' | tr 'a-z' 'A-Z'
}

accessToken="$1"
method="GET"
#rate=600
extra_header="User-Agent:Apache-HttpClient/UNAVAILABLE (java 1.4)"

HOST="http://api.cloud.189.cn"
LOGIN_URL="/loginByOpen189AccessToken.action"
ACCESS_URL="/speed/startSpeedV2.action"

echo "*******************************************"
echo "发起提速请求..."
split="~"
headers_string="$extra_header"
headers=`formatHeaderString "$split" "$headers_string"`
result=`get "$HOST$LOGIN_URL?accessToken=$accessToken" "$headers"`
session_key=`echo "$result" | grep -Eo "sessionKey>.*</sessionKey" | sed 's/<\/sessionKey//' | sed 's/sessionKey>//'`
session_secret=`echo "$result" | grep -Eo "sessionSecret>.*</sessionSecret" | sed 's/sessionSecret>//' | sed 's/<\/sessionSecret//'`

if [ -z "$session_key" ]
then
    echo "登录失败"
else
    date=`env LANG=C.UTF-8 date -u '+%a, %d %b %Y %T GMT'`
    data="SessionKey=$session_key&Operate=$method&RequestURI=$ACCESS_URL&Date=$date"
    key="$session_secret"
    signature=`hashHmac "sha1" "$data" "$key"`
    headers_string="SessionKey:$session_key"${split}"Signature:$signature"${split}"Date:$date"${split}"$extra_header"
    headers=`formatHeaderString "$split" "$headers_string"`
    qosClientSn="2cceaa8d-5721-4782-9637-faff03135779"
    # qosClientSn=`cat /proc/sys/kernel/random/uuid`
    result=`get "$HOST$ACCESS_URL?qosClientSn=$qosClientSn" "$headers"`

    dialAccount=`echo $result | grep -Eo "<dialAccount>.*</dialAccount>" | sed 's/<dialAccount>sh:://' | sed 's/<\/dialAccount>//'`
    baseDownRate=`echo $result | grep -Eo "<baseDownRate>.*</baseDownRate>" | sed 's/<baseDownRate>//' | sed 's/<\/baseDownRate>//'`
    baseUpRate=`echo $result | grep -Eo "<baseUpRate>.*</baseUpRate>" | sed 's/<baseUpRate>//' | sed 's/<\/baseUpRate>//'`
    targetDownRate=`echo $result | grep -Eo "<targetDownRate>.*</targetDownRate>" | sed 's/<targetDownRate>//' | sed 's/<\/targetDownRate>//'`
    targetUpRate=`echo $result | grep -Eo "<targetUpRate>.*</targetUpRate>" | sed 's/<targetUpRate>//' | sed 's/<\/targetUpRate>//'`
fi

if [ -z "$dialAccount" ]
then
    echo "提速失败"
else    
    echo "提速成功"
    echo "宽带账号: $dialAccount"
    echo "套餐带宽: 下行 $((baseDownRate/1024)) Mbps / 上行 $((baseUpRate/1024)) Mbps"
    echo "目前带宽: 下行 $((targetDownRate/1024)) Mbps / 上行 $((targetUpRate/1024)) Mbps"
fi

echo "*******************************************"
exit 0
