CFLAGS += -I.
CFLAGS += -g
#CFLAGS += -pg
CFLAGS += -Wall
CFLAGS += --pedantic
CFLAGS += -O4
#CFLAGS += -DBLISS_DEBUG
CFLAGS += -fPIC

SRCS = defs.cc graph.cc partition.cc orbit.cc uintseqhash.cc heap.cc
SRCS += timer.cc utils.cc bliss_C.cc

OBJS = $(addsuffix .o, $(basename $(SRCS)))

GMPOBJS = $(addsuffix g,  $(OBJS))

LIB =
#LIB += /usr/lib/ccmalloc.o -ldl

CC = g++
RANLIB = ranlib
AR = ar
BLISSLIB = libbliss.a

# Shared library building
SONAME=libbliss.so.1d
SOMINOR=0
SOFULL=$(SONAME).$(SOMINOR)
GMPSHOBJS=$(addsuffix s, $(GMPOBJS))

%.ogs: %.cc
	$(CC) $(CPPFLAGS) -fPIC -c $(CFLAGS) -o $@ $<

gmp_shared gmp:	LIB += -lgmp
gmp_shared gmp:	CFLAGS += -DBLISS_USE_GMP

normal:	bliss
gmp:	bliss_gmp
gmp_shared: bliss_gmp_shared libbliss.so

all:: lib bliss

%.o %.og:	%.cc
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

lib: $(OBJS)
	rm -f $(BLISSLIB)
	$(AR) cr $(BLISSLIB) $(OBJS)
	$(RANLIB) $(BLISSLIB)

lib_gmp: $(GMPOBJS)
	rm -f $(BLISSLIB)
	$(AR) cr $(BLISSLIB) $(GMPOBJS)
	$(RANLIB) $(BLISSLIB)

bliss: bliss.o lib $(OBJS)
	$(CC) $(CFLAGS) -o bliss bliss.o $(OBJS) $(LDFLAGS) $(LIB)

bliss_gmp: bliss.og lib_gmp $(GMPOBJS)
	$(CC) $(CFLAGS) -o bliss bliss.og $(GMPOBJS) $(LDFLAGS) $(LIB)

bliss_gmp_shared: libbliss.so bliss.og
	$(CC) $(CFLAGS) -o bliss bliss.og -L. -lbliss -lgmp $(LDFLAGS)

libbliss.so: $(GMPSHOBJS)
	$(CC) -shared -Wl,-soname,$(SONAME) $(LDFLAGS) $(LIB) -o $(SOFULL) $^
	ln -sf $(SOFULL) $(SONAME)
	ln -sf $(SOFULL) libbliss.so

install: gmp_shared lib
	mkdir -p $(DESTDIR)/usr/lib
	cp libbliss.a $(DESTDIR)/usr/lib
	cp $(SOFULL) $(DESTDIR)/usr/lib
	cd $(DESTDIR)/usr/lib && \
		ln -sf $(SOFULL) $(SONAME) && \
		ln -sf $(SOFULL) libbliss.so
	mkdir -p $(DESTDIR)/usr/include/bliss
	cp *.h $(DESTDIR)/usr/include/bliss
	cp *.hh $(DESTDIR)/usr/include/bliss
	mkdir -p $(DESTDIR)/usr/bin
	cp bliss $(DESTDIR)/usr/bin

clean:
	rm -f bliss $(BLISSLIB) $(OBJS) bliss.o $(GMPOBJS) bliss.og *.ogs *.so*

# DO NOT DELETE
