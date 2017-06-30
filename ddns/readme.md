## Docker 运行方式
#### 环境变量
>Time: 计划运行时间, 格式为 "* 6 * * *".

>Script: 脚本选择, 选脚本有 "dnspod, qcloud, aliyun, cloudxns".

>ApiId: API 密钥 ID, 如 "123456789".

>ApiKey: API 密钥, 如 "f7c3bc1d808e04732adf679965ccc34ca7ae3441".

>Domain: 顶级域名, 如 "example.com"

>SubDomain: 子域名, 如 "www"


## 直接脚本运行方式
#### dnspod (添加 / 更新) *推荐*
```
sh dnspod.sh {ApiID},{ApiKey} example.com www
```
---
#### qcloud (添加 / 更新)
```
sh qcloud.sh {SecretId} {SecretKey} example.com www
```
---
#### aliyun (添加 / 更新)
```
sh aliyun.sh {AccessKeyId} {AccessKeySecret} example.com www
```
---
#### cloudxns (只能更新)
```
sh cloudxns.sh {ApiKey} {SecretKey} example.com www
```
