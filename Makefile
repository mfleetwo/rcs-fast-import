#
# makefile for rcs-fast-import
#
VERS=$(shell sed <rcs-fast-import -n -e '/version=\(.*\)/s//\1/p')

SOURCES = README COPYING NEWS rcs-fast-import rcs-fast-import.xml Makefile control

all: rcs-fast-import.1

rcs-fast-import.1: rcs-fast-import.xml
	xmlto man rcs-fast-import.xml

rcs-fast-import.html: rcs-fast-import.xml
	xmlto html-nochunks rcs-fast-import.xml

clean:
	rm -f  *~ *.1 *.html *.tar.gz MANIFEST SHIPPER.*
	rm -fr .rs* typescript test/typescript

rcs-fast-import-$(VERS).tar.gz: $(SOURCES) rcs-fast-import.1 
	@ls $(SOURCES) rcs-fast-import.1 | sed s:^:rcs-fast-import-$(VERS)/: >MANIFEST
	@(cd ..; ln -s rcs-fast-import rcs-fast-import-$(VERS))
	(cd ..; tar -czvf rcs-fast-import/rcs-fast-import-$(VERS).tar.gz `cat rcs-fast-import/MANIFEST`)
	@(cd ..; rm rcs-fast-import-$(VERS))

pychecker:
	@echo "Expect four messages about unknown methods checkin and maketag."
	@ln -f rcs-fast-import rcs-fast-import.py
	@-pychecker --quiet --only --limit 50 rcs-fast-import.py
	@rm -f rcs-fast-import.py rcs-fast-import.pyc

version:
	@echo $(VERS)

dist: rcs-fast-import-$(VERS).tar.gz

release: rcs-fast-import-$(VERS).tar.gz rcs-fast-import.html
	shipper -u -m -t; make clean
