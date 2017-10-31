SHELL       := /bin/sh

# Directory paths
MAKEFILEDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SRCROOT     := $(MAKEFILEDIR)src
OUTDIR      := $(MAKEFILEDIR)build
OBJDIR      := $(OUTDIR)/.obj
DSYMSFILE   := $(OUTDIR)/dump_syms

# Compiler options
CXX         := g++
CXXFLAGS    := -w -pipe -std=c++14
INCPATH     := -I$(SRCROOT)
OBJEXT      := o

OBJECTS     := \
    ./PDBParser.$(OBJEXT) \
    ./dump_syms.$(OBJEXT) \
    ./utils.$(OBJEXT)

.PHONY: all
all: $(DSYMSFILE)

$(DSYMSFILE): $(OBJECTS)
	@test -d $(OUTDIR) || mkdir -p $(OUTDIR)
	@test -d $(dir $(DSYMSFILE)) || mkdir -p $(dir $(DSYMSFILE))
	$(CXX) $(CXXFLAGS) $(INCPATH) $(wildcard $(OBJDIR)/*) -o $(DSYMSFILE)

$(OBJECTS): %.$(OBJEXT) : $(SRCROOT)/%.cpp
	@test -d $(OBJDIR) || mkdir -p $(OBJDIR)
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o $(OBJDIR)/$(@F) $<

.PHONY: clean
clean:
	-rm -f $(OBJECTS) $(DSYMSFILE)

.PHONY: distclean
distclean: clean
	-rm -rf $(OBJDIR)