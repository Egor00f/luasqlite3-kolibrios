# Makefile for lsqlite3 library for Lua
# This file is old and crufty. 
# manual setup (change these to reflect your Lua installation)


CC=kos32-gcc
LD=kos32-ld
STRIP=kos32-strip
OBJCOPY=kos32-objcopy

KOLIBRIOS_REPO=../kolibrios

C_LAYER_DIR=$(KOLIBRIOS_REPO)/contrib/C_Layer
LUA_DIR=../lua-kolibrios
SQLITE3_DIR=$(SDK_DIR)/sources/sqlite3

SDK_DIR=$(KOLIBRIOS_REPO)/contrib/sdk
NewLib_DIR=$(SDK_DIR)/sources/newlib
SYSCFLAGS=-fno-ident -fomit-frame-pointer -U__WIN32__ -U_Win32 -U_WIN32 -U__MINGW32__ -UWIN32 -I$(NewLib_DIR)/libc/include -I$(C_LAYER_DIR)/INCLUDE -I$(LUA_DIR)/src
SYSLDFLAGS=--image-base 0 -Tapp-dynamic.lds
SYSLIBS=-nostdlib -L $(SDK_DIR)/lib -L$(TOOLCHAIN_PATH)/lib -L$(TOOLCHAIN_PATH)/mingw32/lib -lgcc -lc.dll -ldll

LUAINC= -I$(LUA_DIR)/src
LUALIB=$(LUA_DIR)/src/lua54.dll
SQLITE3INC= -I$(SQLITE3_DIR)
SQLITE3LIB= -L$(SQLITE3_DIR) -lsqlite3.dll
#  Windows' LUALIB is the same as the Lua executable's directory...
#  LUALIB= -L$(BASE)/bin -llua51
#
POD2HTML= perl -x -S doc/pod2html.pl

TMP=./tmp
DISTDIR=./archive

# OS detection
#
SHFLAGS=-shared
UNAME= $(shell uname)

_SO=dll

ifndef _SO
  $(error $(UNAME))
  $(error Unknown OS)
endif

# no need to change anything below here - HAH!
CFLAGS=$(SYSCFLAGS) $(INCS) $(DEFS) $(WARN) -O2 #$(SHFLAGS) 
WARN= -Wall #-ansi -pedantic
INCS= $(LUAINC) $(SQLITE3INC)
LIBS= $(SYSLIBS) $(LUALIB) $(SQLITE3LIB)
SOFLAGS=-T dll.lds --entry _DllStartup

MYNAME= sqlite3
MYLIB= l$(MYNAME)

VER=$(shell svnversion -c . | sed 's/.*://')
TARFILE = $(DISTDIR)/$(MYLIB)-$(VER).tar.gz

OBJS= extras/extension-functions.o $(MYLIB).o
T= $(MYLIB).$(_SO)

all: $(T)

test: $(T)
	$(LUAEXE) test.lua
	$(LUAEXE) tests-sqlite3.lua

$(T):	$(OBJS) $(LUALIB)
	$(CC) $(SHFLAGS) $(SOFLAGS) -o $@ $(OBJS) $(LIBS)

install: $(T) $(OBJS) $(SQLITE3_DIR)/libsqlite3.dll.a
	$(INSTALL) $< `$(INSTALLPATH) $(MYLIB)`

clean:
	rm -f $(OBJS) $T core

html:
	$(POD2HTML) --title="LuaSQLite 3" --infile=doc/lsqlite3.pod --outfile=doc/lsqlite3.html

dist:	html
	echo 'Exporting...'
	mkdir -p $(TMP)
	mkdir -p $(DISTDIR)
	svn export . $(TMP)/$(MYLIB)-$(VER)
	mkdir -p $(TMP)/$(MYLIB)-$(VER)/doc
	cp -p doc/lsqlite3.html $(TMP)/$(MYLIB)-$(VER)/doc
	echo 'Compressing...'
	tar -zcf $(TARFILE) -C $(TMP) $(MYLIB)-$(VER)
	rm -fr $(TMP)/$(MYLIB)-$(VER)
	echo 'Done.'

.PHONY: all test clean dist install

$(MYLIB).o: lsqlite3.c
extras/extension-functions.o: extras/extension-functions.c
$(SQLITE3_DIR)/libsqlite3.dll.a: 
	$(MAKE) -C $(SQLITE3_DIR) libsqlite3.dll.a
$(LUALIB):
	$(MAKE) -C $(LUAINC) lua54.dll
