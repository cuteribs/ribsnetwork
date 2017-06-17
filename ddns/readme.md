```
docker run \
-e Time="* 6 * * *" \							# update at 06:00 everyday
-e Token="22222,xxxxxxxxxxxxxxxxxxxx" \			# login token for dnspod.cn
-e Domain="mydomain.com" \						# domain name
-e SubDomain="www" \							# sub domain name
cuteribs/dnspod
```
