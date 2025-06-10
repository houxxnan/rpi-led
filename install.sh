#!/bin/bash
set -e

echo "欢迎使用 LED 守护程序安装向导"

read -p "请输入 LED 关闭开始时间（小时，0-23，例如 22）: " ON_START
read -p "请输入 LED 关闭结束时间（小时，0-23，例如 8）: " ON_END

if ! [[ "$ON_START" =~ ^[0-9]+$ ]] || ! [[ "$ON_END" =~ ^[0-9]+$ ]] || [ "$ON_START" -gt 23 ] || [ "$ON_END" -gt 23 ]; then
  echo "输入无效，时间必须是0~23之间的整数。"
  exit 1
fi

echo "请选择定时任务类型："
echo "1) systemd Timer (推荐)"
echo "2) cron Job"
read -p "请输入选项数字 (1 或 2): " TIMER_TYPE

if [[ "$TIMER_TYPE" != "1" && "$TIMER_TYPE" != "2" ]]; then
  echo "无效选项，退出安装。"
  exit 1
fi

echo "设置LED关闭时间段为 ${ON_START} 点到 ${ON_END} 点。"

cat > config.h << EOF
#ifndef CONFIG_H
#define CONFIG_H

#define ON_START $ON_START
#define ON_END $ON_END

#endif
EOF

echo "生成配置文件 config.h"

make clean
make

echo "复制可执行文件..."
sudo chmod 755 /usr/local/bin/ledctl /usr/local/bin/led-daemon

if [ "$TIMER_TYPE" = "1" ]; then
  echo "安装 systemd 定时器..."

  sudo cp systemd/led-daemon.service /etc/systemd/system/
  sudo cp systemd/led-daemon.timer /etc/systemd/system/
  sudo chmod 644 /etc/systemd/system/led-daemon.service /etc/systemd/system/led-daemon.timer
  sudo systemctl daemon-reload
  sudo systemctl enable --now led-daemon.timer

  echo "systemd 定时器已启用，使用命令查看状态： sudo systemctl status led-daemon.timer"

else
  echo "安装 cron 任务..."

  # 写入用户crontab，假设定时器每5分钟运行一次led-daemon
  (crontab -l 2>/dev/null | grep -v 'led-daemon') | crontab -
  (crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/led-daemon") | crontab -

  echo "cron 任务已安装，使用命令查看crontab： crontab -l"
fi

echo "LED 守护程序安装完成。"
