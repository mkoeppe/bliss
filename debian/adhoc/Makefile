TOP_BUILDDIR ?= _build

## inspired by the bliss web site frontpage <http://www.tcs.hut.fi/Software/bliss/>
bliss_DESCRIPTION = "compute automorphism groups and canonical labelings of graphs"
bliss_DOX_PROJECT_NAME = "bliss: Source Code Documentation"

DOXYGEN = doxygen

HELP2MAN = help2man

H2MFLAGS = \
	--manual="bliss" \
	--source="bliss (Debian $(DEB_PKG_VERSION))" \
	--version-option=-version \
	--help-option=-help \
	--libtool \
	--no-info

default:

ABS_DOCDIR=$(abspath $(TOP_BUILDDIR))/DEBIAN/doc
doc: Doxyfile
	mkdir -p $(ABS_DOCDIR)
	cp -p $< $(ABS_DOCDIR)/Doxyfile
	echo "OUTPUT_DIRECTORY = $(ABS_DOCDIR)" >> $(ABS_DOCDIR)/Doxyfile
	echo "PROJECT_NUMBER = \"$(UPS_PKG_VERSION) (Debian $(DEB_PKG_VERSION))\"" >> $(ABS_DOCDIR)/Doxyfile
	sed -i \
			-e 's|PROJECT_NAME\([\ ]*\)=\([\ ]*\)$$|PROJECT_NAME = $(bliss_DOX_PROJECT_NAME)|' \
			-e 's|GENERATE_LATEX\([\ ]*\)=\([\ ]*\)NO|GENERATE_LATEX = YES|' \
			-e 's|LATEX_CMD_NAME\([\ ]*\)=\([\ ]*\)NO|LATEX_CMD_NAME = pdflatex|' \
			-e 's|PDF_HYPERLINKS\([\ ]*\)=\([\ ]*\)NO|PDF_HYPERLINKS = YES|' \
			-e 's|USE_PDFLATEX\([\ ]*\)=\([\ ]*\)NO|USE_PDFLATEX = YES|' \
			-e 's|LATEX_BATCHMODE\([\ ]*\)=\([\ ]*\)NO|LATEX_BATCHMODE = YES|' \
		$(ABS_DOCDIR)/Doxyfile
	cd $(<D) && $(DOXYGEN) $(ABS_DOCDIR)/Doxyfile
	cd $(ABS_DOCDIR)/html && { \
		rm -f *.md5 jquery.js ; \
		rdfind -outputname /dev/null -makesymlinks true . ; \
		symlinks -r -c -s -v . ; \
		ln -sf /usr/share/javascript/jquery/jquery.js ; \
		}
	cd $(ABS_DOCDIR)/latex && { \
		make && mv refman.pdf bliss_refman.pdf ; \
		}

manpages: bliss.1

bliss.1: $(TOP_BUILDDIR)/bliss
	$(HELP2MAN) \
			-s 1 \
			$(H2MFLAGS) \
			-I debian/man/$(basename $@).h2m \
			-n $(if $($(basename $@)_DESCRIPTION), $($(basename $@)_DESCRIPTION), "manual page for $(basename $@)") \
			-o $@ \
		./$<
