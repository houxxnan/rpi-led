#!/bin/bash

echo "正在卸载 LED 守护程序..."

# 关闭并禁用 systemd 定时器和服务（如果存在）
if systemctl list-units --full -all | grep -q "led-daemon.timer"; then
    echo "检测到 systemd 定时器，正在禁用..."
    sudo systemctl stop led-daemon.timer led-daemon.service
    sudo systemctl disable led-daemon.timer led-daemon.service
    sudo rm -f /etc/systemd/system/led-daemon.service
    sudo rm -f /etc/systemd/system/led-daemon.timer
    sudo systemctl daemon-reload
    echo "已移除 systemd 定时器。"
fi

# 移除 cron 任务（如果存在）
if crontab -l 2>/dev/null | grep -q "led-daemon"; then
    echo "检测到 cron 任务，正在移除..."
    crontab -l | grep -v 'led-daemon' | crontab -
    echo "已移除 cron 任务。"
fi

# 删除可执行文件（如果存在）
echo "正在删除已安装的二进制文件..."
sudo rm -f /usr/local/bin/ledctl
sudo rm -f /usr/local/bin/led-daemon

# 删除配置头文件
rm -f config.h

echo "LED 守护程序已卸载完成。"
