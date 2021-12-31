# Development dir
# (Embed html file in release)
UIDIR?="file://$(CURDIR)/ui/output.html"

CPP=c++
CPPFLAG=-Wall -g -lstdc++ `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0`

CC=gcc
CFLAG=-c -D UIDIR='$(UIDIR)'

FILES=fbrp/fbrp.o main.o haplous/get.o haplous/haplous.o haplous/info.o

heb12: kjv.txt webview.o $(FILES)
	$(CPP) *.o $(CPPFLAG) -o heb12

%.o: %.c
	$(CC) $(CFLAG) $< -o $(notdir $@)

webview.o: webview.cpp
	$(CPP) -c webview.cpp $(CPPFLAG) -o webview.o

ui/output.html: ui/main.m4
	m4 -D DESKTOP main.m4 > output.html

clean:
	rm -rf heb12 *.o

webview.cpp:
	wget -4 https://raw.githubusercontent.com/zserge/webview/master/webview.h -O webview.cpp

kjv.txt:
	wget -4 http://api.heb12.com/translations/haplous/kjv.txt -O kjv.txt
