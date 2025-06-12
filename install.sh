#!/bin/sh

# 检测是否 root 用户，如果不是，使用 sudo 重新运行脚本
if [ "$(id -u)" != "0" ]; then
  echo "当前不是 root 用户，尝试使用 sudo 提升权限..."
  exec sudo "$0" "$@"
fi

# 下面是你的安装逻辑...
# 安装 LED 守护程序，兼容 sh/bash/zsh

echo "欢迎使用 LED 守护程序安装向导"

printf "请输入 LED 关闭开始时间（小时，0-23，例如 22）: "
read ON_START
printf "请输入 LED 关闭结束时间（小时，0-23，例如 8）: "
read ON_END

# 兼容所有 shell 的整数校验方式
case "$ON_START" in
  ''|*[!0-9]*) echo "❌ 开始时间不是整数"; exit 1 ;;
esac

case "$ON_END" in
  ''|*[!0-9]*) echo "❌ 结束时间不是整数"; exit 1 ;;
esac

if [ "$ON_START" -gt 23 ] || [ "$ON_END" -gt 23 ]; then
  echo "❌ 时间必须在 0~23 之间"
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
install -m 755 ledctl /usr/local/bin/ledctl
install -m 755 led-daemon /usr/local/bin/led-daemon

echo ""
echo "请选择启动方式："
echo "1) 使用 systemd (推荐)"
echo "2) 使用 init.d (SysV)"
echo "3) 使用 rc.local (嵌入式/兜底方案)"
printf "请输入选项数字 (1/2/3): "
read BOOT_TYPE

if [ "$BOOT_TYPE" = "1" ]; then
  echo "安装 systemd 服务..."
  cp systemd/led-daemon.service /etc/systemd/system/
  chmod 644 /etc/systemd/system/led-daemon.service
  systemctl daemon-reload
  systemctl enable led-daemon.service
  systemctl restart led-daemon.service
  echo "✅ systemd 服务已启用。"

elif [ "$BOOT_TYPE" = "2" ]; then
  echo "安装 init.d 脚本..."
  cp init.d/led-daemon /etc/init.d/led-daemon
  chmod +x /etc/init.d/led-daemon
  update-rc.d led-daemon defaults
  /etc/init.d/led-daemon restart
  echo "✅ init.d 脚本已安装并启动。"

elif [ "$BOOT_TYPE" = "3" ]; then
  echo "配置 rc.local..."
  RC_LOCAL=/etc/rc.local
  if [ ! -f "$RC_LOCAL" ]; then
    echo "#!/bin/sh" > "$RC_LOCAL"
    echo "exit 0" >> "$RC_LOCAL"
    chmod +x "$RC_LOCAL"
  fi
  # 删除旧的再添加
  sed -i '/led-daemon/d' "$RC_LOCAL"
  sed -i '/exit 0/i /usr/local/bin/led-daemon &' "$RC_LOCAL"
  /usr/local/bin/led-daemon &
  echo "✅ rc.local 已配置并启动。"

else
  echo "❌ 无效选项，退出安装。"
  exit 1
fi

echo ""
echo " LED 守护程序安装完成。"
