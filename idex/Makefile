all:
	cp -r /opt/dsf/sd/sys/. .
	find . -name '*.g' -exec dos2unix '{}' \;

install:
	sudo cp *.g /opt/dsf/sd/sys/
	sudo chmod a+rw /opt/dsf/sd/sys/*.g
