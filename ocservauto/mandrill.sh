#!/bin/bash
#mandrill api curl
#Fullfill api-key and domian
#bash mandrill.sh 'my.p12' '123@123.com'

API_KEY=""
DOMAIN=""

FILE_NAME="$1"
EMAIL_AD="$2"
FROM_NAME="Ocserv"
SUBJECT="Ocserv-Clientcert"
MIME_TYPE="application\/x-pkcs12"
#MIME_TYPE="text\/plain"
#MIME_TYPE="application\/x-openvpn-profile"
FILE_BASE64=`base64 ${FILE_NAME}`
USER_NAME=`echo ${EMAIL_AD}|cut -d@ -f1`
HTML="<p>${USER_NAME}您好！</p><br /><p>${FROM_NAME}为您生成了一份证书文件。</p><p><b>附件当中的${FILE_NAME}</b>文件是为您生成的身份证书，用于您在使用服务时，提供给服务
器的身份凭据。</p><br /><p><i>请将上面的证书导入您的终端。</i></p><br /><br /><p><b>请不要回复此邮件，谢谢!</b><p>"

JSON="{\"key\":\"${API_KEY}\""
JSON="${JSON},\"message\":{\"html\":\"$HTML\""
JSON="${JSON},\"subject\":\"$SUBJECT\""
JSON="${JSON},\"from_email\":\"no-reply@${DOMAIN}\",\"from_name\":\"${FROM_NAME}\""
JSON="${JSON},\"to\":[{\"email\":\"${EMAIL_AD}\""
JSON="${JSON},\"name\":\"${USER_NAME}\",\"type\":\"to\"}]"
JSON="${JSON},\"headers\":{\"Reply-To\":\"${EMAIL_AD}\"}"
JSON="${JSON},\"merge\":true"
JSON="${JSON},\"attachments\":[{\"type\":\"${MIME_TYPE}\""
JSON="${JSON},\"name\":\"${FILE_NAME}\""
JSON="${JSON},\"content\":\"${FILE_BASE64}\"}]}"
JSON="${JSON},\"ip_pool\":\"Main Pool\"}"

#保留json文件取消下一行注释
#echo $JSON > ${USER_NAME}.json

CMD="curl -A 'Mandrill-Curl/1.0' -d '${JSON}' 'https://mandrillapp.com/api/1.0/messages/send.json'"
eval $CMD
