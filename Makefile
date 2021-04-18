PLATFORM ?= desktop

CC := g++
CFLAGS := -lstdc++ `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0`

default: compile demo

compile:
	@cd ui; node builder.js $(PLATFORM)
	@$(CC) $(CFLAGS) main.c -o heb12

demo:
	@./heb12

setup:
	wget https://raw.githubusercontent.com/zserge/webview/master/webview.h
