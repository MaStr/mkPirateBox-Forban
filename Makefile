VERSION = 0.2.1
NAME = piratebox-forban
ARCH = all
GITURL = "https://github.com/adulau/Forban/zipball/master"
GITFILE = forban.zip
WGET = wget -c
FORBANFOLDER = forban-src
IMAGE_FILE=forban_img.gz
IMAGE_FILE_TGZ=forban_img.tar.gz
SRC_IMAGE=image_stuff/OpenWRT.img.gz
SRC_IMAGE_UNPACKED=image_stuff/forban_img
MOUNT_POINT=image_stuff/image
CUSTOM_MOD_FOLDER=pre_config

IPK = $(NAME)_$(VERSION)_$(ARCH).ipk
IPKDIR = src

.DEFAULT_GOAL = all



$(IPKDIR)/control.tar.gz: $(IPKDIR)/control
	tar czf $@ -C $(IPKDIR)/control .

control: $(IPKDIR)/control.tar.gz 

$(IPKDIR)/data.tar.gz: $(IPKDIR)/data
	tar czf $@ -C $(IPKDIR)/data .

data: $(IPKDIR)/data.tar.gz 

$(IPK): $(IPKDIR)/control.tar.gz $(IPKDIR)/data.tar.gz $(IPKDIR)/control $(IPKDIR)/data
	tar czf $@ -C $(IPKDIR) control.tar.gz data.tar.gz debian-binary



$(FORBANFOLDER):
	mkdir -p  $(FORBANFOLDER)

$(GITFILE):  $(FORBANFOLDER)
	wget -c   $(GITURL)  -O $(GITFILE)
	mv $@ $(FORBANFOLDER)
	cd  $(FORBANFOLDER) && unzip $@ && mv -v  adulau-Forban*/* ./
	ls $(FORBANFOLDER)/adulau-Forban* >  $(FORBANFOLDER)/version
	rm -rv  $(FORBANFOLDER)/adulau-Forban*
	rm  $(FORBANFOLDER)/$(GITFILE)



$(IMAGE_FILE): $(SRC_IMAGE_UNPACKED) 
	echo "#### Mounting image-file"
	sudo  mount -o loop,rw,sync $(SRC_IMAGE_UNPACKED) $(MOUNT_POINT)
	echo "#### Copy content to image file"
	sudo  	cp -vr $(FORBANFOLDER)/*  $(MOUNT_POINT)     
	echo "#### Copy customizatiosns to image file"
	sudo   cp -vr $(CUSTOM_MOD_FOLDER)/* $(MOUNT_POINT) 
	echo "#### Umount Image file"
	sudo  umount  $(MOUNT_POINT)
	gzip -rc $(SRC_IMAGE_UNPACKED) > $(IMAGE_FILE)

$(IMAGE_FILE_TGZ): 
	tar czf $(IMAGE_FILE_TGZ)  $(SRC_IMAGE_UNPACKED) 

$(SRC_IMAGE_UNPACKED): 
	gunzip -dc $(SRC_IMAGE) >  $(SRC_IMAGE_UNPACKED)

cleanpackage: 
	- rm -rv  $(FORBANFOLDER) 

cleanbuild: 
	- rm -f $(IPK) 
	- rm -f $(IPKDIR)/control.tar.gz
	- rm -f $(IPKDIR)/data.tar.gz	

clean: cleanpackage cleanbuild cleanimage

cleanimage:
	- rm -f $(SRC_IMAGE_UNPACKED)
	- rm -f $(IMAGE_FILE_TGZ)
	- rm -v $(IMAGE_FILE) 

 
all: image $(IPK)

ipk:  $(IPK)

image:  $(GITFILE) shortimage

shortimage: $(IMAGE_FILE) $(IMAGE_FILE_TGZ) 

.PHONY: all image ipk clean shortimage


