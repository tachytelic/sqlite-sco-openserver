#!/bin/sh
SCRIPT_DIR=`dirname $0`
PREFIX=${1:-/usr/local}
mkdir -p $PREFIX/bin $PREFIX/include
cp $SCRIPT_DIR/bin/sqlite3 $PREFIX/bin/sqlite3
chmod 755 $PREFIX/bin/sqlite3
cp $SCRIPT_DIR/include/sqlite3.h $PREFIX/include/sqlite3.h
echo "Installed sqlite3 3.39.4 to $PREFIX"
$PREFIX/bin/sqlite3 --version
