
# rpi-led

一个用于树莓派的 LED 定时控制守护程序，支持 `systemd` 和 `cron` 两种定时方式。用户可通过交互式安装脚本，自定义 LED 的关闭时间段，实现夜间关闭、白天开启的节能效果。

---

## ✨ 功能特性

- ⏰ 定时控制 LED 开关
-  支持 systemd timer 与 cron job
- ‍ 安装过程可交互，自动生成配置文件
- ⚙️ 完整 Makefile 构建、安装、部署流程
-  提供卸载脚本，干净移除所有安装项

---

## 项目结构
[查看完整结构](doc/tree.txt)
##  安装说明

### 1. 克隆仓库
```
bash
git clone https://github.com/houxxnan/rpi-led.git
cd rpi-led
````
### 2. 运行安装脚本
````
sudo bash install.sh
```
输入关闭开始时间（小时）和结束时间（小时）

选择定时方式（systemd 或 cron）


### 3. 查看运行状态（若选择 systemd）
```
sudo systemctl status led-daemon.timer
```

---

# ❌ 卸载程序

要完全卸载 LED 定时守护程序：
```
sudo bash uninstall.sh

```
---

# ⚙️ 编译说明（可选手动执行）

你也可以手动编译守护进程：
```
make
```
或使用：
```
gcc -Wall -DON_START=22 -DON_END=8 led-daemon.c -o led-daemon

```
---

 # 依赖环境

Linux（推荐 Raspberry Pi OS）

make 和 gcc

systemd 或 cron

可控制的 GPIO 接口用于 LED



---

 # 测试方式

安装完成后，观察 LED 是否在设定时间段内关闭/开启

可通过 systemctl status 或 journalctl -u led-daemon.service 查看日志

手动执行 ledctl（若启用）进行 LED 状态检测



---

 开源协议

本项目使用 MIT License 开源，您可自由使用、修改、分发，需保留原作者信息。

版权所有 © houxnan

