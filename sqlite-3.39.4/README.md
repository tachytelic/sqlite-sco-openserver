# SQLite 3.39.4 for SCO OpenServer 5

Download the precompiled tarball from the [Releases](../../../releases) page: `sqlite-3.39.4-sco507.tar.gz`

## Installation

```sh
cd /tmp
gzip -d sqlite-3.39.4-sco507.tar.gz | tar xf -
cd sqlite-sco-pkg
sh install.sh
```

This installs to `/usr/local/bin/sqlite3` and `/usr/local/include/sqlite3.h`. To install to a different prefix:

```sh
sh install.sh /opt/local
```

## Version Ceiling

**3.39.4 is the latest SQLite that compiles with GCC 2.95.3 on SCO OpenServer 5.**

Versions 3.40 and above fail at link time due to GCC builtins and libc functions that were introduced into SQLite's codebase after 3.39:

| Missing symbol | Reason |
|---|---|
| `__builtin_clzll` | Count-leading-zeros builtin not in GCC 2.95.3 |
| `__builtin_floor` / `__builtin_ceil` | Math builtins not linked on this GCC |
| `strtoll` | C99 string-to-int64 not in SCO's libc |
| `nanosleep` | POSIX high-res sleep not in SCO's libc |

## Compilation Notes

The main obstacle is that GCC 2.95.3 does not see declarations for `fchmod`, `fchown`, `readlink` and `lstat` before SQLite's static syscall table is initialised. The fix is a small prefix header (`sco_compat.h`) that forces the right system headers in early:

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
```

SCO OpenServer 5 has no pthreads library, so threading must be disabled at compile time.

Full build command:

```sh
gcc -O2 -o sqlite3 shell.c sqlite3.c \
    -include sco_compat.h \
    -DSQLITE_THREADSAFE=0 \
    -DSQLITE_OMIT_LOAD_EXTENSION \
    -lm -ldl
```

The `noinline` and `always_inline` attribute warnings from GCC 2.95.3 are harmless.

## Package Contents

```
sqlite-sco-pkg/
  bin/sqlite3        — compiled binary
  include/sqlite3.h  — C header
  src/sqlite3.c      — amalgamation source
  src/shell.c        — CLI shell source
  src/sco_compat.h   — SCO-specific prefix header
  install.sh         — installs bin + header to /usr/local (or PREFIX=$1)
  rebuild.sh         — recompiles from source using the exact working flags
```

If the binary doesn't run on a different patch level of SCO, use `rebuild.sh` to recompile from source — GCC 2.95.3 must be installed.
