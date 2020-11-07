all:	grid-show hex2ascii clean-slic3r-bundle slic3r-to-files stl2ascii \
	slic3r.ini slic3r/timestamp 

# Don't autogenerate slic3r-bundle because it overwrites the expanded files
generate: slic3r-bundle.ini

grid-show: grid-show.c
	$(CC) grid-show.c -o grid-show -lm

hex2ascii: hex2ascii.c
	$(CC) hex2ascii.c -o hex2ascii

clean-slic3r-bundle: clean-slic3r-bundle.c
	$(CC) clean-slic3r-bundle.c -o clean-slic3r-bundle

stl2ascii: stl2ascii.c
	$(CC) stl2ascii.c -o stl2ascii

slic3r-to-files: slic3r-to-files.c
	$(CC) slic3r-to-files.c -o slic3r-to-files -lm

slic3r.ini: clean-slic3r-bundle PrusaSlicer_config_bundle.ini
	./clean-slic3r-bundle < PrusaSlicer_config_bundle.ini > slic3r.ini

.PHONY: slic3r-bundle.ini
slic3r-bundle.ini:
	./generate-slic3r-bundle.sh >$@

slic3r/timestamp: slic3r.ini slic3r-to-files
	mkdir -p slic3r
	cd slic3r && ../slic3r-to-files < ../slic3r.ini
	touch slic3r/timestamp
