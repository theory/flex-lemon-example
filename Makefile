CFLAGS := $(CFLAGS) -std=c99

shell: main.o shellparser.o shellscanner.o
	$(CC) -o shell main.o shellparser.o shellscanner.o

main.o: main.c shellparser.h shellscanner.h

shellparser.o: shellparser.h shellparser.c

shellparser.h shellparser.c: shellparser.y lemon
	./lemon shellparser.y

shellscanner.o: shellscanner.h

shellscanner.h: shellscanner.l
	flex --outfile=shellscanner.c --header-file=shellscanner.h shellscanner.l

# Prevent yacc from trying to build parsers.
# http://stackoverflow.com/a/5395195/79202
%.c: %.y

lemon: lemon.c
	$(CC) -o lemon lemon.c

.PHONY: clean
clean:
	rm -f *.o
	rm -f shellscanner.c shellscanner.h
	rm -f shellparser.c shellparser.h shellparser.out
	rm -f shell lemon
