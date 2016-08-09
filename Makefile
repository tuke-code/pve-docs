DGDIR=.

include ./pve-doc-generator.mk

GEN_PACKAGE=pve-doc-generator
DOC_PACKAGE=pve-docs
MEDIAWIKI_PACKAGE=pve-docs-mediawiki

# also update debian/changelog
PKGREL=7

GITVERSION:=$(shell cat .git/refs/heads/master)

ARCH:=$(shell dpkg-architecture -qDEB_BUILD_ARCH)

GEN_DEB=${GEN_PACKAGE}_${DOCRELEASE}-${PKGREL}_${ARCH}.deb
DOC_DEB=${DOC_PACKAGE}_${DOCRELEASE}-${PKGREL}_all.deb
MEDIAWIKI_DEB=${MEDIAWIKI_PACKAGE}_${DOCRELEASE}-${PKGREL}_all.deb

CHAPTER_LIST=		\
	sysadmin	\
	pvecm		\
	pmxcfs		\
	pvesm		\
	qm		\
	pve-firewall	\
	pveum		\
	pct		\
	ha-manager	\
	vzdump		\
	pve-faq		\
	pve-bibliography

STORAGE_TYPES=		\
	dir		\
	glusterfs	\
	iscsi		\
	iscsidirect	\
	lvm		\
	lvmthin		\
	nfs		\
	rbd		\
	zfspool

COMMAND_LIST=		\
	pvesubscription	\
	pvecm 		\
	qm 		\
	qmrestore 	\
	pveceph		\
	pct 		\
	pveam 		\
	pvesm 		\
	pveum 		\
	vzdump 		\
	ha-manager

SERVICE_LIST=		\
	pve-firewall 	\
	pve-ha-crm 	\
	pve-ha-lrm 	\
	pvestatd 	\
	pmxcfs 		\
	pveproxy	\
	spiceproxy	\
	pvedaemon

CONFIG_LIST=datacenter.cfg qm.conf pct.conf

GEN_DEB_SOURCES=				\
	pve-doc-generator.mk			\
	attributes.txt				\
	$(addsuffix .adoc, ${COMMAND_LIST}) 	\
	$(addsuffix .adoc, ${SERVICE_LIST}) 	\
	$(addsuffix .adoc, ${CONFIG_LIST}) 	\
	pve-storage-dir.adoc 			\
	pve-storage-glusterfs.adoc		\
	pve-storage-iscsi.adoc			\
	pve-storage-iscsidirect.adoc		\
	pve-storage-lvm.adoc			\
	pve-storage-nfs.adoc			\
	pve-storage-rbd.adoc			\
	pve-storage-zfspool.adoc		\
	pmxcfs.8-cli.adoc			\
	pve-copyright.adoc			\
	docinfo.xml

GEN_SCRIPTS=					\
	gen-datacenter.cfg.5-opts.pl		\
	gen-pct.conf.5-opts.pl			\
	gen-pct-network-opts.pl			\
	gen-pct-mountpoint-opts.pl		\
	gen-qm.conf.5-opts.pl			\
	gen-vzdump.conf.5-opts.pl		\
	gen-pve-firewall-cluster-opts.pl	\
	gen-pve-firewall-host-opts.pl		\
	gen-pve-firewall-macros-adoc.pl		\
	gen-pve-firewall-rules-opts.pl		\
	gen-pve-firewall-vm-opts.pl

SYSADMIN_SOURCES=				\
	getting-help.adoc			\
	pve-package-repos.adoc			\
	pve-installation.adoc			\
	system-software-updates.adoc		\
	sysadmin.adoc

API_VIEWER_SOURCES=				\
	api-viewer/index.html			\
	api-viewer/apidoc.js

PVE_ADMIN_GUIDE_SOURCES=			\
	${DATACENTER_CONF_MAN5_SOURCES}		\
	${QM_CONF_MAN5_SOURCES}			\
	${PCT_CONF_MAN5_SOURCES}		\
	${SYSADMIN_SOURCES}			\
	pve-admin-guide.adoc			\
	pve-intro.adoc				\
	pmxcfs.adoc 				\
	pmxcfs.8-cli.adoc			\
	pve-faq.adoc				\
	${PVE_FIREWALL_MAN8_SOURCES}		\
	${PVESM_MAN1_SOURCES}			\
	${PCT_MAN1_SOURCES}			\
	${PVECM_MAN1_SOURCES}			\
	${PVEUM_MAN1_SOURCES}			\
	${QM_MAN1_SOURCES}			\
	${QMRESTORE_MAN1_SOURCES}		\
	${HA_MANAGER_MAN1_SOURCES}		\
	${PVESTATD_MAN8_SOURCES}		\
	${PVEDAEMON_MAN8_SOURCES}		\
	${PVEPROXY_MAN8_SOURCES}		\
	${SPICEPROXY_MAN8_SOURCES}		\
	${PVE_HA_CRM_MAN8_SOURCES}		\
	${PVE_HA_LRM_MAN8_SOURCES}		\
	${VZDUMP_MAN1_SOURCES}			\
	${PVEAM_MAN1_SOURCES}			\
	${PVESUBSCRIPTION_MAN1_SOURCES}		\
	${PVECEPH_MAN1_SOURCES}			\
	pve-bibliography.adoc			\
	$(addsuffix .adoc, ${COMMAND_LIST}) 	\
	$(addsuffix .adoc, ${SERVICE_LIST}) 	\
	$(addsuffix .adoc, ${CONFIG_LIST}) 	\
	GFDL.adoc				\
	attributes.txt

WIKI_IMPORTS=								\
	$(addsuffix -plain.html, $(addprefix chapter-, ${CHAPTER_LIST}))\
	$(addsuffix .5-plain.html, ${CONFIG_LIST})			\
	$(addsuffix -plain.html, $(addprefix pve-storage-, ${STORAGE_TYPES}))

INDEX_INCLUDES=								\
	pve-admin-guide.pdf 						\
	pve-admin-guide.html 						\
	pve-admin-guide.epub 						\
	$(addsuffix .1.html, ${COMMAND_LIST}) 				\
	$(addsuffix .8.html, ${SERVICE_LIST}) 				\
	$(addsuffix .5.html, ${CONFIG_LIST}) 				\
	$(addsuffix .html, $(addprefix chapter-, ${CHAPTER_LIST}))

ADOC_STDARG= -a icons -a data-uri -a "date=$(shell date)" -a "revnumber=${DOCRELEASE}"
ADOC_MAN1_HTML_ARGS=-a "manvolnum=1" ${ADOC_STDARG}
ADOC_MAN5_HTML_ARGS=-a "manvolnum=5" ${ADOC_STDARG}
ADOC_MAN8_HTML_ARGS=-a "manvolnum=8" ${ADOC_STDARG}

BROWSER?=xdg-open

all: index.html

%-nwdiag.svg: %.nwdiag
	nwdiag -T svg $*.nwdiag -o $@;

chapter-%.html: %.adoc ${PVE_COMMON_DOC_SOURCES}
	asciidoc ${ADOC_STDARG} -a toc -o $@ $*.adoc

chapter-%-plain.html: %.adoc ${PVE_COMMON_DOC_SOURCES}
	asciidoc -s -a wiki ${ADOC_STDARG} -o $@ $*.adoc

pve-storage-%-plain.html: pve-storage-%.adoc ${PVE_COMMON_DOC_SOURCES}
	asciidoc -s -a wiki -a 'leveloffset=-1' ${ADOC_STDARG} -o $@ pve-storage-$*.adoc

%.1.html: %.adoc %.1-synopsis.adoc ${PVE_COMMON_DOC_SOURCES}
	asciidoc ${ADOC_MAN1_HTML_ARGS} -o $@ $*.adoc

pmxcfs.8.html: pmxcfs.adoc pmxcfs.8-cli.adoc ${PVE_COMMON_DOC_SOURCES}
	asciidoc ${ADOC_MAN8_HTML_ARGS} -o $@ pmxcfs.adoc

%.8.html: %.adoc %.8-synopsis.adoc ${PVE_COMMON_DOC_SOURCES}
	asciidoc ${ADOC_MAN8_HTML_ARGS} -o $@ $*.adoc

%.5.html: %.adoc %.5-opts.adoc ${PVE_COMMON_DOC_SOURCES}
	asciidoc ${ADOC_MAN5_HTML_ARGS} -o $@ $*.adoc

%.5-plain.html: %.adoc %.5-opts.adoc ${PVE_COMMON_DOC_SOURCES}
	asciidoc -s ${ADOC_MAN5_HTML_ARGS} -o $@ $*.adoc

.PHONY: index
index: index.html
	$(BROWSER) index.html &

index.html: index.adoc ${API_VIEWER_SOURCES} ${INDEX_INCLUDES} 
	asciidoc -a "date=$(shell date)" -a "revnumber=${DOCRELEASE}" index.adoc

pve-admin-guide.html: ${PVE_ADMIN_GUIDE_SOURCES}
	asciidoc -a "revnumber=${DOCRELEASE}" -a "date=$(shell date)" pve-admin-guide.adoc

pve-admin-guide.chunked: ${PVE_ADMIN_GUIDE_SOURCES}
	rm -rf pve-admin-guide.chunked
	a2x -a docinfo -a docinfo1 -a icons -f chunked pve-admin-guide.adoc

pve-admin-guide.pdf: ${PVE_ADMIN_GUIDE_SOURCES} docinfo.xml pve-admin-guide-docinfo.xml
	grep ">Release ${DOCRELEASE}<" pve-admin-guide-docinfo.xml || (echo "wrong release in  pve-admin-guide-docinfo.xml" && false);
	a2x -a docinfo -a docinfo1 -f pdf -L --dblatex-opts "-P latex.output.revhistory=0" --dblatex-opts "-P latex.class.options=12pt" --dblatex-opts "-P doc.section.depth=2 -P toc.section.depth=2" pve-admin-guide.adoc

pve-admin-guide.epub: ${PVE_ADMIN_GUIDE_SOURCES}
	a2x -f epub pve-admin-guide.adoc

api-viewer/apidata.js: extractapi.pl
	./extractapi.pl >$@

api-viewer/apidoc.js: api-viewer/apidata.js api-viewer/PVEAPI.js
	cat api-viewer/apidata.js api-viewer/PVEAPI.js >$@

.PHONY: dinstall
dinstall: ${GEN_DEB} ${DOC_DEB} ${MEDIAWIKI_DEB}
	dpkg -i ${GEN_DEB} ${DOC_DEB} ${MEDIAWIKI_DEB}

.PHONY: deb
deb:
	rm -f ${GEN_DEB} ${DOC_DEB} ${MEDIAWIKI_DEB};
	make ${GEN_DEB} ${DOC_DEB} ${MEDIAWIKI_DEB};

${GEN_DEB} ${DOC_DEB} ${MEDIAWIKI_DEB}: index.html ${INDEX_INCLUDES} ${WIKI_IMPORTS} ${API_VIEWER_SOURCES} ${GEN_DEB_SOURCES}
	rm -rf build
	mkdir build
	rsync -a debian/ build/debian
	echo "git clone git://git.proxmox.com/git/pve-docs.git\\ngit checkout ${GITVERSION}" > build/debian/SOURCE
	# install files for pve-doc-generator package
	mkdir -p build/usr/share/${GEN_PACKAGE}
	mkdir -p build/usr/share/doc/${GEN_PACKAGE}
	install -m 0644 ${GEN_DEB_SOURCES} build/usr/share/${GEN_PACKAGE}
	install -m 0755 ${GEN_SCRIPTS} build/usr/share/${GEN_PACKAGE}
	# install files for pvedocs package
	mkdir -p build/usr/share/${DOC_PACKAGE}
	mkdir -p build/usr/share/doc/${DOC_PACKAGE}
	install -m 0644 index.html ${INDEX_INCLUDES} build/usr/share/${DOC_PACKAGE}
	install -m 0644 ${WIKI_IMPORTS} build/usr/share/${DOC_PACKAGE}
	# install api doc viewer
	mkdir build/usr/share/${DOC_PACKAGE}/api-viewer
	install -m 0644 ${API_VIEWER_SOURCES} build/usr/share/${DOC_PACKAGE}/api-viewer
	# build Debian packages
	cd build; dpkg-buildpackage -rfakeroot -b -us -uc
	lintian ${GEN_DEB}
	lintian ${DOC_DEB}
	lintian ${MEDIAWIKI_DEB}

.PHONY: upload
upload: ${GEN_DEB} ${DOC_DEB} ${MEDIAWIKI_DEB}
	umount /pve/${DOCRELEASE}; mount /pve/${DOCRELEASE} -o rw
	mkdir -p /pve/${DOCRELEASE}/extra
	rm -f /pve/${DOCRELEASE}/extra/${GEN_PACKAGE}_*.deb
	rm -f /pve/${DOCRELEASE}/extra/${DOC_PACKAGE}_*.deb
	rm -f /pve/${DOCRELEASE}/extra/Packages*
	cp ${GEN_DEB} ${DOC_DEB} ${MEDIAWIKI_DEB} /pve/${DOCRELEASE}/extra
	cd /pve/${DOCRELEASE}/extra; dpkg-scanpackages . /dev/null > Packages; gzip -9c Packages > Packages.gz
	umount /pve/${DOCRELEASE}; mount /pve/${DOCRELEASE} -o ro

.PHONY: update
update: clean
	rm -f *.5-opts.adoc *.1-synopsis.adoc *.8-synopsis.adoc
	rm -f api-viewer/apidata.js
	rm -f pve-firewall-macros.adoc pct-network-opts.adoc pct-mountpoint-opts.adoc
	make all

clean: 
	rm -rf *.tmp.xml *.html *.pdf *.epub *.tmp *.1 *.5 *.8 *.deb *.changes build api-viewer/apidoc.js chapter-*.html chapter-*-plain.html chapter-*.html pve-admin-guide.chunked
	find . -name '*~' -exec rm {} ';'
