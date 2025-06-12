# rpi-led

一个用于 **树莓派** 的 LED 定时控制守护程序，支持 `systemd`、`init.d` 和 `rc.local` 三种启动方式。通过交互式安装脚本，用户可自定义 LED 的关闭时间段，实现夜间自动关闭、白天自动开启的节能效果。

---

## ✨ 功能特性

- ⏰ **定时控制** LED 开关（按小时段）
- ⚙️ 支持 **systemd timer**、**init.d** 和 **rc.local**
-  **交互式安装**，自动生成配置文件
-  提供完整 `Makefile` 构建与部署流程
-  提供卸载脚本，**干净移除** 所有文件与服务

---

##  项目结构

[点击查看完整目录结构](doc/tree.txt)

---

## ️ 安装说明

### 1. 克隆仓库

```
git clone https://github.com/houxxnan/rpi-led.git
cd rpi-led
```
###2. 设置执行权限（bash/zsh 用户都适用）

```
# 使用 bash
sudo bash install.shchmod +x install.sh uninstall.sh ```
```

### 3. 运行安装脚本
```
# 使用 bash
sudo bash install.sh
```
输入关闭开始时间（小时）和结束时间（小时）

启动方式（systemd / init.d / rc.local）

### 4. 查看运行状态

如果选择了 systemd：
```
sudo systemctl status led-daemon.service
```
如果选择了 init.d：
```
sudo service led-daemon status
```
如果使用了 rc.local，可查看 /etc/rc.local 内容：
```
cat /etc/rc.local
```
---

## ❌ 卸载程序

要完全卸载 LED 定时守护程序：
```
sudo bash uninstall.sh

```
---

## ⚙️ 编译说明（可选手动执行）

你也可以手动编译守护进程：
```
make

或使用：
gcc -Wall -DON_START=[开启时间] -DON_END=[结束时间] led-daemon.c -o led-daemon

```
---

## 依赖环境

Linux 系统（推荐 Raspberry Pi OS）

make 和 gcc

支持以下三种启动方式之一：

systemd

init.d

rc.local


可控制 GPIO 接口的 LED 设备


---

## 测试方法

安装后等待对应时间段，观察 LED 状态是否变化

查看日志：
```
systemctl status led-daemon.service

journalctl -u led-daemon.service


手动执行：

/usr/local/bin/ledctl
```



---

## 开源协议

本项目使用 MIT License 开源，您可自由使用、修改、分发，需保留原作者信息。

版权所有 © houxnan

