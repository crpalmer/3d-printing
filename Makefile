CFLAGS = -Wall -Werror

all:	grid-show hex2ascii generate-slic3r-bundle slic3r-to-files stl2ascii \
	slic3r/timestamp slic3r-bundle.ini

grid-show: grid-show.c
	$(CC) $(CFLAGS) grid-show.c -o grid-show -lm

hex2ascii: hex2ascii.c
	$(CC) $(CFLAGS) hex2ascii.c -o hex2ascii

stl2ascii: stl2ascii.c
	$(CC) $(CFLAGS) stl2ascii.c -o stl2ascii

OBJS = config.o group.o utils.o
slic3r-to-files: slic3r-to-files.c $(OBJS)
	$(CC) $(CFLAGS) slic3r-to-files.c $(OBJS) -o slic3r-to-files -lm

OBJS = config.o group.o utils.o
generate-slic3r-bundle: generate-slic3r-bundle.c $(OBJS)
	$(CC) $(CFLAGS) generate-slic3r-bundle.c $(OBJS) -o generate-slic3r-bundle -lm

config.o: config.h utils.h config.c
group.o: config.h group.h group.c
utils.o: utils.h utils.c

.PHONY: slic3r-bundle.ini
slic3r-bundle.ini:
	./generate-slic3r-bundle >$@

slic3r/timestamp: PrusaSlicer_config_bundle.ini slic3r-to-files
	mkdir -p slic3r
	cd slic3r && ../slic3r-to-files < ../PrusaSlicer_config_bundle.ini
	touch slic3r/timestamp
