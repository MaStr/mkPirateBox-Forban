VERSION = 0.1
NAME = piratebox-forban
GITURL = "https://github.com/adulau/Forban/zipball/master"
GITFILE = forban.zip
WGET = wget -c
FORBANFOLDER = forban-src

.DEFAULT_GOAL = all

$(FORBANFOLDER):
	mkdir -p  $(FORBANFOLDER)

$(GITFILE):  $(FORBANFOLDER)
	wget -c   $(GITURL)  -O $(GITFILE)
	mv $@ $(FORBANFOLDER)
	cd  $(FORBANFOLDER) && unzip $@ && mv -v  adulau-Forban*/* ./
	rm -rv  $(FORBANFOLDER)/adulau-Forban*
	rm $(GITFILE)

cleanpackage: 
	rm -rv  $(FORBANFOLDER)


cleanall: cleanpackage 
	echo ""

all: $(GITFILE) install

install: 
	echo "empty"

.PHONY: all install  cleanall


