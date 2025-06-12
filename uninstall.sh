#!/bin/sh
set -e

echo " 欢迎使用 LED 守护程序卸载程序"

printf "确认要卸载 LED 守护程序吗？[y/N]: "
read confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "取消卸载。"
  exit 0
fi

# 停止 systemd 服务（如果存在）
if command -v systemctl >/dev/null 2>&1 && systemctl list-units --all | grep -q led-daemon.service; then
  echo " 停止并禁用 systemd 服务..."
  sudo systemctl stop led-daemon.service || true
  sudo systemctl disable led-daemon.service || true
  sudo rm -f /etc/systemd/system/led-daemon.service
  sudo systemctl daemon-reload
fi

# 卸载 init.d 脚本（如果存在）
if [ -f /etc/init.d/led-daemon ]; then
  echo " 卸载 init.d 服务..."
  sudo /etc/init.d/led-daemon stop || true
  sudo update-rc.d -f led-daemon remove
  sudo rm -f /etc/init.d/led-daemon
fi

# 移除 rc.local 中的启动命令（如果存在）
if [ -f /etc/rc.local ]; then
  echo " 清理 rc.local..."
  sudo sed -i '/led-daemon/d' /etc/rc.local
fi

# 删除可执行文件和构建文件
echo "️ 删除程序文件..."
sudo rm -f /usr/local/bin/led-daemon /usr/local/bin/ledctl
rm -f config.h
make clean || true

echo "✅ LED 守护程序已完全卸载。"
