all:	grid-show hex2ascii clean-slic3r-bundle slic3r.ini

grid-show: grid-show.c
	$(CC) grid-show.c -o grid-show -lm

hex2ascii: hex2ascii.c
	$(CC) hex2ascii.c -o hex2ascii

clean-slic3r-bundle: clean-slic3r-bundle.c
	$(CC) clean-slic3r-bundle.c -o clean-slic3r-bundle

slic3r.ini: clean-slic3r-bundle Slic3r_config_bundle.ini
	./clean-slic3r-bundle < Slic3r_config_bundle.ini > slic3r.ini
