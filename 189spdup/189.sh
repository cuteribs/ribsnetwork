#!/usr/sh

hashHmac() {
    digest="$1"
    data="$2"
    key="$3"
    echo -n "$data" | openssl dgst "-$digest" -hmac "$key" | sed -e 's/^.* //' | tr 'a-z' 'A-Z'
}

accessToken="$1"

HOST="http://api.cloud.189.cn"
LOGIN_URL="/loginByOpen189AccessToken.action"
ACCESS_URL="/speed/startSpeedV2.action"

echo "*******************************************"
echo "发起提速请求..."
result=`curl -s --connect-timeout 15 -m 15 "$HOST$LOGIN_URL?accessToken=$accessToken"`
session_key=`echo "$result" | grep -Eo "sessionKey>.*</sessionKey" | sed 's/<\/sessionKey//' | sed 's/sessionKey>//'`
session_secret=`echo "$result" | grep -Eo "sessionSecret>.*</sessionSecret" | sed 's/sessionSecret>//' | sed 's/<\/sessionSecret//'`

if [ -z "$session_key" ]
then
    echo "登录失败"
else
    date=`env LANG=C.UTF-8 date -u '+%a, %d %b %Y %T GMT'`
    data="SessionKey=$session_key&Operate=GET&RequestURI=$ACCESS_URL&Date=$date"
    signature=`echo -n "$data" | openssl dgst -sha1 -hmac $session_secret | sed -e 's/^.* //' | tr 'a-z' 'A-Z'`
    qosClientSn=`cat /proc/sys/kernel/random/uuid`
    result=`curl -s --connect-timeout 15 -m 15 "$HOST$ACCESS_URL?qosClientSn=$qosClientSn" -H "SessionKey:$session_key" -H "Signature:$signature" -H "Date:$date"`
    
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
