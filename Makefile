# TODO: Precompiled header?
# I tried everthing, it just didn't work, as if the feature was
# never implemented in GCC.
# Also, C is being compiled with C++ compiler.
# This is bad.

PLATFORM ?= desktop

# Development dir
UIDIR ?= "file://$(CURDIR)/ui/output.html"

CC := gcc
CPP := c++
CPPFLAG := -Wall -g -lstdc++ `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0`
CFLAG := -c -D UIDIR='$(UIDIR)'

default: ui main

html:
	@cd ui; node builder.js $(PLATFORM)

# Source code files must be declared before
# libs for some reason
main:
	@$(CPP) -c webview.c $(CPPFLAG) -o webview.o
	@$(CC) $(CFLAG) fbrp/fbrp.c
	@$(CC) $(CFLAG) main.c
	@$(CC) $(CFLAG) haplous/get.c
	@$(CC) $(CFLAG) haplous/haplous.c
	@$(CC) $(CFLAG) haplous/info.c
	@$(CPP) *.o $(CPPFLAG) -o heb12

clean:
	@rm heb12 *.o

setup:
	-sudo apt install libwebkit2gtk-4.0-dev
	wget -4 https://raw.githubusercontent.com/zserge/webview/master/webview.h
	wget -4 http://api.heb12.com/translations/haplous/kjv.txt
