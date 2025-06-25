.POSIX:

PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

CC      = cc
CFLAGS  = -std=c11 -march=native -O3 -Icompat -D_GNU_SOURCE -D 'DEF_WEAK(n)=_Static_assert(1, "")'
LDFLAGS = -s -static

SRC = doas.c env.c persist.c y.tab.c\
      compat/readpassphrase.c\
      compat/reallocarray.c\
      compat/setprogname.c\
      compat/strtonum.c
OBJ = $(SRC:.c=.o)

all: doas

.c.o:
	$(CC) $(CFLAGS) -o $@ -c $<

y.tab.c:
	yacc parse.y

clean:
	rm -f *.o compat/*.o doas y.tab.c

doas: $(OBJ)
	$(CC) -o $@ $(OBJ) $(LDFLAGS)

install: doas
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f doas $(DESTDIR)$(PREFIX)/bin
	chmod 4555 $(DESTDIR)$(PREFIX)/bin/doas
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	cp doas.1 $(DESTDIR)$(MANPREFIX)/man1/
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/doas.1
	mkdir -p $(DESTDIR)$(MANPREFIX)/man5
	cp doas.conf.5 $(DESTDIR)$(MANPREFIX)/man5/
	chmod 644 $(DESTDIR)$(MANPREFIX)/man5/doas.conf.5

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/doas
	rm -f $(DESTDIR)$(MANPREFIX)/man1/doas.1
	rm -f $(DESTDIR)$(MANPREFIX)/man5/doas.conf.5

.PHONY: all clean install uninstall
