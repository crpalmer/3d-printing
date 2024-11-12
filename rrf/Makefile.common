all:
	cp -r /opt/dsf/sd/sys/. sys/
	cp -r /opt/dsf/sd/macros/. macros/
	find sys/ -name '*.g' -exec dos2unix '{}' \;
	find macros/ -type f -exec dos2unix '{}' \;

install:
	sudo cp sys/*.g /opt/dsf/sd/sys/
	sudo chmod -R a+rw /opt/dsf/sd/sys/
	sudo cp -r macros/* /opt/dsf/sd/macros/
	sudo chmod -R a+rw /opt/dsf/sd/macros/
