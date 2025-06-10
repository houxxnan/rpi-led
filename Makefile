CC = gcc
CFLAGS = -Wall -O2

BIN_DIR = /usr/local/bin

TARGETS = ledctl led-daemon

all: $(TARGETS)

ledctl: ledctl.c
	$(CC) $(CFLAGS) -o $@ $<

led-daemon: led-daemon.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(TARGETS)

.PHONY: all clean
