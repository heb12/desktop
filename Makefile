# TODO: Precompiled header?
# I tried everthing, it just didn't work, as if the feature was
# never implemented in GCC.
# Also, C is being compiled with C++ compiler.
# This is bad.

PLATFORM ?= desktop

# Development dir
UIDIR ?= "file://$(CURDIR)/ui/output.html"

CC := g++
CFLAGS := -fpermissive -Wall -g -O0 -lstdc++ `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0`

HAPLOUS := $(shell ls haplous/*.c | grep -v test.c)

default: ui main demo

html:
	@cd ui; node builder.js $(PLATFORM)

main:
	# Source code files must be declared before
	# libs for some reason
	@$(CC) -D UIDIR='$(UIDIR)' $(HAPLOUS) webview.h fbrp/fbrp.c main.c $(CFLAGS) -o heb12

demo:
	@./heb12

clean:
	@rm heb12

setup:
	sudo apt install webkit2gtk-4.0
	wget https://raw.githubusercontent.com/zserge/webview/master/webview.h
