PLATFORM ?= desktop

# Send in development dir
UIDIR ?= "file://$(CURDIR)/ui/output.html"

CC := g++
CFLAGS := -Wall -lstdc++ `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0`

default: compile demo

compile:
	@cd ui; node builder.js $(PLATFORM)
	@$(CC) -D UIDIR='$(UIDIR)' $(CFLAGS) main.c -o heb12

demo:
	@./heb12

setup:
	wget https://raw.githubusercontent.com/zserge/webview/master/webview.h
