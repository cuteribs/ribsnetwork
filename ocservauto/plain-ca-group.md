##开启分组模式

这里分为两组all和route，一个帐号可以选择全局模式（all）或国内外分流模式（route）。

=====

###用户密码方式分组

在ocserv.conf文件中取消相应行的注释，并且修改为如下值

```
select-group = Route
select-group = All
auto-select-group = false
config-per-group = /etc/ocserv/config-per-group
```

需要注意的是，`select-group`这一项的值，是后面所讲的配置文件的`文件全名`。

修改或者创建组用户，下面的username是自定义的用户名

```shell
ocpasswd -c /etc/ocserv/ocpasswd  -g "Route,All" username
```
如果您使用是该脚本进行安装，进行到此步骤即可重启服务器了。下面的文件夹和文件都已被脚本自动创建了。

如果没有相关文件和文件夹，请根据说明继续进行操作。

创建放置分流组配置文件的文件夹

```shell
mkdir /etc/ocserv/config-per-group
```

写入国内外分流路由规则（规则可以自定，只要写入/etc/ocserv/config-per-group/Route 文件中即可）

我们可以参考来自 https://github.com/humiaozuzu/ocserv-build 的一份优化好的路由表来完成分流，可以通过下面命令来配置

```shell
wget https://raw.githubusercontent.com/fanyueciyuan/eazy-for-ss/master/ocservauto/Route -O /etc/ocserv/config-per-group/Route
```

然后创建一个空的All文件

```
touch /etc/ocserv/config-per-group/All
```

最后重启ocserv即可

```shell
service ocserv restart
```

====

###证书方式分组
default-select-group = all 默认组的配置，无法载入，测试失败。

