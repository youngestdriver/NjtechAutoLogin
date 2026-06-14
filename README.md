# NjtechAutoLogin

南京工业大学宿舍区校园网自动登录脚本。

## 功能

- 支持 Windows 批处理脚本和 OpenWrt Shell 脚本。
- OpenWrt 脚本会自动从认证页获取 `WANIP`。
- OpenWrt 脚本会优先使用 `curl`，没有 `curl` 时自动使用 `wget`。
- 登录接口返回内容后会自动补换行，避免命令提示符接在返回结果后面。

## 配置

推荐复制 `.env.example` 为 `.env`，然后填写账号、密码和运营商：

```sh
USERID=20xxxxxxxxx
PASSWORD=abcdefxxxxxx
CHANNEL=cmcc
```

运营商可选值：

- 中国移动：`cmcc`
- 中国电信：`telecom`

如果希望直接在脚本中配置，也可以修改 `login_openwrt.sh` 或 `login_windows.bat` 里的对应变量。

## OpenWrt 使用

上传 `login_openwrt.sh` 和 `.env` 到 OpenWrt，然后赋予执行权限：

```sh
chmod +x login_openwrt.sh
./login_openwrt.sh
```

如果系统没有 `curl`，但有 BusyBox/系统自带的 `wget`，脚本会自动使用 `wget`，不需要额外修改。

也可以安装 `curl`：

```sh
opkg update
opkg install curl
```

## 定时执行

可以在 OpenWrt 的 crontab 中定时执行，例如每 5 分钟检测一次：

```cron
*/5 * * * * /root/login_openwrt.sh
```

修改后重启 cron：

```sh
/etc/init.d/cron restart
```
