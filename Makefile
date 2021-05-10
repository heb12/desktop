# TODO: Precompiled header?
# I tried everthing, it just didn't work, as if the feature was
# never implemented in GCC.


PLATFORM ?= desktop

# Development dir
UIDIR ?= "file://$(CURDIR)/ui/output.html"

CC := g++
CFLAGS := -Wall -g -lstdc++ `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0`

default: ui main demo

ui:
	@cd ui; node builder.js $(PLATFORM)

main:
	@$(CC) -D UIDIR='$(UIDIR)' $(CFLAGS) main.c -o heb12

demo:
	@./heb12

setup:
	sudo apt install webkit2gtk-4.0
	wget https://raw.githubusercontent.com/zserge/webview/master/webview.h
