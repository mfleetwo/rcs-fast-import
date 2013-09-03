#
# makefile for rcs-fast-import
#
VERS=$(shell sed <rcs-fast-import -n -e '/version *= *\(.*\)/s//\1/p')

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

PYLINTOPTS = --rcfile=/dev/null --reports=n --include-ids=y --disable="C0103,C0111,C0301,C0323,R0902,R0903,R0912,R0913,R0914,R0915,W0141,W0333,W0142,W0621,E1101"
pylint:
	@pylint --output-format=parseable $(PYLINTOPTS) rcs-fast-import

version:
	@echo $(VERS)

dist: rcs-fast-import-$(VERS).tar.gz

release: rcs-fast-import-$(VERS).tar.gz rcs-fast-import.html
	shipper -u -m -t; make clean
