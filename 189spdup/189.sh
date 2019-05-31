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
rate=600
extra_header="User-Agent:Apache-HttpClient/UNAVAILABLE (java 1.4)"

HOST="http://api.cloud.189.cn"
LOGIN_URL="/loginByOpen189AccessToken.action"
ACCESS_URL="/speed/startSpeedV2.action"

    echo "Sending heart_beat package <$count>"
    split="~"
    headers_string="$extra_header"
    headers=`formatHeaderString "$split" "$headers_string"`
    result=`get "$HOST$LOGIN_URL?accessToken=$accessToken" "$headers"`
    session_key=`echo "$result" | grep -Eo "sessionKey>.*</sessionKey" | sed 's/<\/sessionKey//' | sed 's/sessionKey>//'`
    session_secret=`echo "$result" | grep -Eo "sessionSecret>.*</sessionSecret" | sed 's/sessionSecret>//' | sed 's/<\/sessionSecret//'`
    date=`env LANG=C.UTF-8 date -u '+%a, %d %b %Y %T GMT'`
    data="SessionKey=$session_key&Operate=$method&RequestURI=$ACCESS_URL&Date=$date"
    key="$session_secret"
    signature=`hashHmac "sha1" "$data" "$key"`
    headers_string="SessionKey:$session_key"${split}"Signature:$signature"${split}"Date:$date"${split}"$extra_header"
    headers=`formatHeaderString "$split" "$headers_string"`
	qosClientSn="2cceaa8d-5721-4782-9637-faff03135779"
    # qosClientSn=`cat /proc/sys/kernel/random/uuid`
    result=`get "$HOST$ACCESS_URL?qosClientSn=$qosClientSn" "$headers"`
	echo $result
	exit 0
    echo "heart_beat:<signature:$signature>"
    echo "date:<$date>"
    echo -e "response:\n$result"
    [[ "`echo ${result} | grep dialAcc`" != "" ]] &&  hint="succeeded" || hint="failed"
    echo "Sending heart_beat package <$count> $hint"
    echo "*******************************************"
    sleep ${rate}