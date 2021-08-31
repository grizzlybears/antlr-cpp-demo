#
# simple Makefile template :)
#
Target=demo


gen=generated
gramma=$(gen)/libgramma.a 


app_src:=$(wildcard *.cpp)

all_src:= $(app_src)
Objs:=$(patsubst %.cpp,%.o,$(all_src)) 

antlr_root:=/home/szr/research/antlr/cpp-runtime/usr/local
antlr_include:=$(antlr_root)/include/antlr4-runtime
antlr_static:=$(antlr_root)/lib/libantlr4-runtime.a

#      以下摘自 `info make`
#
#Compiling C programs
# `N.o' is made automatically from `N.c' with a recipe of the form
#  `$(CC) $(CPPFLAGS) $(CFLAGS) -c'.
#
#Compiling C++ programs
#  `N.o' is made automatically from `N.cc', `N.cpp', or `N.C' with a recipe of the form 
#  `$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c'.  
#  We encourage you to use the suffix `.cc' for C++ source files insteadof `.C'.
#
#Linking a single object file
#  `N' is made automatically from `N.o' by running the linker
#  (usually called `ld') via the C compiler.  The precise recipe used
#  is `$(CC) $(LDFLAGS) N.o $(LOADLIBES) $(LDLIBS)'.

CC = g++
CXX= g++


CPPFLAGS=  -DDEBUG -I. -I $(gen)/  -I$(antlr_include) -DUSE_UTF8_INSTEAD_OF_CODECVT
CFLAGS= -ggdb3 -Wall -MMD  -pthread -fPIC -std=c++11
CXXFLAGS= $(CFLAGS)

LDFLAGS= -pthread 
LOADLIBES=
LDLIBS= $(antlr_static)


##########################################################################

Deps= $(Objs:.o=.d) 

all:$(Target)

-include $(Deps)

demo:$(gramma) $(Objs)
	$(CC) $(Objs) $(gramma) $(LDFLAGS)  $(LOADLIBES) $(LDLIBS) -o $@

$(gramma):
	cd gramma;./generate.sh

YCM:
	make clean
	make > build.log
	compiledb -p build.log

clean:
	rm -fr $(Objs) $(Target) $(Deps) $(gen) gramma/*.o

test:demo
	./demo

