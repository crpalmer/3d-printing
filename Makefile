all:	grid-show hex2ascii slic3r-to-files stl2ascii \
	slic3r/timestamp 

# Don't autogenerate slic3r-bundle because it overwrites the expanded files
generate: slic3r-bundle.ini

grid-show: grid-show.c
	$(CC) grid-show.c -o grid-show -lm

hex2ascii: hex2ascii.c
	$(CC) hex2ascii.c -o hex2ascii

stl2ascii: stl2ascii.c
	$(CC) stl2ascii.c -o stl2ascii

STF_OBJS = config.o utils.o
slic3r-to-files: slic3r-to-files.c $(STF_OBJS)
	$(CC) slic3r-to-files.c $(STF_OBJS) -o slic3r-to-files -lm

config.o: config.h utils.h config.c
utils.o: utils.h utils.c

.PHONY: slic3r-bundle.ini
slic3r-bundle.ini:
	./generate-slic3r-bundle.sh >$@

slic3r/timestamp: PrusaSlicer_config_bundle.ini slic3r-to-files
	mkdir -p slic3r
	cd slic3r && ../slic3r-to-files < ../PrusaSlicer_config_bundle.ini
	touch slic3r/timestamp
