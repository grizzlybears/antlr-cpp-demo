#!/bin/bash  -e
set -o errexit

# Created 2016, Mike Lischke (public domain)

# This script is used to generate source files from the test grammars in the same folder. The generated files are placed
# into a subfolder "generated" which the demo project uses to compile a demo binary.

target_dir=../generated
target=$target_dir/libgramma.a 

LOCATION=/home/szr/research/antlr/binary/antlr-4.9.2-complete.jar
java -jar $LOCATION -Dlanguage=Cpp -listener -visitor -o $target_dir -package antlrcpptest TLexer.g4 TParser.g4
#java -jar $LOCATION -Dlanguage=Cpp -listener -visitor -o generated/ -package antlrcpptest -XdbgST TLexer.g4 TParser.g4
#java -jar $LOCATION -Dlanguage=Java -listener -visitor -o generated/ -package antlrcpptest TLexer.g4 TParser.g4



antlr_root=/home/szr/research/antlr/cpp-runtime/usr/local
antlr_include=$antlr_root/include/antlr4-runtime

CPPFLAGS=" -DDEBUG -I. -I$antlr_include -DUSE_UTF8_INSTEAD_OF_CODECVT"
CFLAGS=" -ggdb3 -Wall  -pthread -fPIC -std=c++11"


src="$target_dir/TLexer.cpp $target_dir/TParser.cpp \
    $target_dir/TParserBaseListener.cpp $target_dir/TParserBaseVisitor.cpp \
    $target_dir/TParserListener.cpp $target_dir/TParserVisitor.cpp "


g++ $CPPFLAGS $CFLAGS -c $src

ar rcs $target  *.o 

