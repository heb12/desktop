# Development dir
# (Embed html file in release)
UIDIR ?= "file://$(CURDIR)/ui/output.html"

CPP := c++
CPPFLAG := -Wall -g -lstdc++ `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0`

CC := gcc
CFLAG := -c -D UIDIR='$(UIDIR)'

default: ui main

# Source code files must be declared before
# libs for some reason
main: webview.o
	@cd ui; m4 -D DESKTOP main.m4 > output.html
	@$(CC) $(CFLAG) fbrp/fbrp.c
	@$(CC) $(CFLAG) main.c
	@$(CC) $(CFLAG) haplous/get.c
	@$(CC) $(CFLAG) haplous/haplous.c
	@$(CC) $(CFLAG) haplous/info.c
	@$(CPP) *.o $(CPPFLAG) -o heb12

webview.o:
	@$(CPP) -c webview.c $(CPPFLAG) -o webview.o

clean:
	@rm heb12 *.o

setup:
	-sudo apt install libwebkit2gtk-4.0-dev
	wget -4 https://raw.githubusercontent.com/zserge/webview/master/webview.h
	wget -4 http://api.heb12.com/translations/haplous/kjv.txt
