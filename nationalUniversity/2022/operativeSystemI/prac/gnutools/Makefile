# paths
BINDIR=./bin
INCDIR=./inc
LIBDIR=./lib
# options
OPTION=-Wall -Werror -Wextra -pedantic
# objects
LDOBJ=main.o opp.o msj.o
# names
LIBNAME=tools
APPNAME=main

# default
all: main opp msj
	gcc -o $(BINDIR)/$(APPNAME) *.o

# depend
main: main.c $(INCDIR)/tools.h
	gcc $(OPTION) -c main.c

opp: $(INCDIR)/opp.c $(INCDIR)/tools.h
	gcc $(OPTION) -c $(INCDIR)/opp.c 

msj: $(INCDIR)/msj.c $(INCDIR)/tools.h
	gcc $(OPTION) -c $(INCDIR)/msj.c 

# libs
buildstatic: libstatic main 
	gcc -static -o $(BINDIR)/$(APPNAME) main.o -L $(LIBDIR) -l $(LIBNAME)

libstatic: opp msj 
	ar crov $(LIBDIR)/lib$(LIBNAME).a *.o

builddynamic: main.c libdynamic 
	gcc $(OPTION) -o $(BINDIR)/$(APPNAME) main.c -L $(LIBDIR) -Wl,-rpath=$(LIBDIR) -l tools

libdynamic: fpicobj 
	gcc -shared -o $(LIBDIR)/lib$(LIBNAME).so *.o

fpicobj: $(INCDIR)/opp.c $(INCDIR)/msj.c $(INCDIR)/tools.h  
	gcc $(OPTION) -c -fPIC $(INCDIR)/opp.c $(INCDIR)/msj.c 

# clean files
clean: *.o 
	rm -i $(BINDIR)/$(APPNAME) *.o $(LIBDIR)/*.a $(LIBDIR)/*.so