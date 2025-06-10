#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>

#include "config.h"

#define LED_CMD "/usr/local/bin/ledctl"
#define SLEEP_INTERVAL 300  // 5分钟

#ifndef ON_START
#error "ON_START is not defined"
#endif

#ifndef ON_END
#error "ON_END is not defined"
#endif

void handle_signal(int sig) {
    printf("收到信号 %d，准备退出...\n", sig);
    exit(0);
}

int main() {
    signal(SIGINT, handle_signal);
    signal(SIGTERM, handle_signal);

    printf("启动led-daemon...\n");
    printf("关闭灯时间段：%d点到%d点\n", ON_START, ON_END);

    while (1) {
        time_t now = time(NULL);
        struct tm *tm_now = localtime(&now);
        int hour = tm_now->tm_hour;

        // 判断时间段，关闭或打开灯
        if ((ON_START < ON_END && (hour >= ON_START && hour < ON_END)) ||
            (ON_START > ON_END && (hour >= ON_START || hour < ON_END))) {
            // 关闭灯
            char cmd[256];
            snprintf(cmd, sizeof(cmd), "%s off", LED_CMD);
            system(cmd);
        } else {
            // 打开灯
            char cmd[256];
            snprintf(cmd, sizeof(cmd), "%s on", LED_CMD);
            system(cmd);
        }

        sleep(SLEEP_INTERVAL);
    }
    return 0;
}
