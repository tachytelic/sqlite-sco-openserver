#!/bin/sh
SCRIPT_DIR=`dirname $0`
PREFIX=${1:-/usr/local}
echo "Building SQLite 3.39.4..."
cd $SCRIPT_DIR/src && gcc -O2 -o ../bin/sqlite3 shell.c sqlite3.c \
    -include sco_compat.h \
    -DSQLITE_THREADSAFE=0 \
    -DSQLITE_OMIT_LOAD_EXTENSION \
    -lm -ldl 2>&1 | grep -v noinline
if [ $? -eq 0 ]; then
    echo "Build OK"
    $SCRIPT_DIR/bin/sqlite3 --version
else
    echo "Build FAILED"
    exit 1
fi
