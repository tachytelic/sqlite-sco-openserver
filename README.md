# SQLite 3.39.4 for SCO OpenServer 5

Precompiled SQLite 3.39.4 for SCO OpenServer 5.0.6 / 5.0.7, compiled with GCC 2.95.3.

More background on the [blog post](https://tachytelic.net/2017/07/sco-openserver-stuff/).

## Download

Download `sqlite-3.39.4-sco507.tar.gz` from the [Releases](../../releases) page.

## Installation

```sh
cd /tmp
gzip -d sqlite-3.39.4-sco507.tar.gz | tar xf -
cd sqlite-sco-pkg
sh install.sh
```

Installs to `/usr/local/bin/sqlite3` and `/usr/local/include/sqlite3.h`. To use a different prefix:

```sh
sh install.sh /opt/local
```

## Version Ceiling

**3.39.4 is the latest SQLite that compiles with GCC 2.95.3 on SCO OpenServer 5.**

Versions 3.40 and above fail at link time due to GCC builtins and libc functions introduced into SQLite after 3.39:

| Missing symbol | Reason |
|---|---|
| `__builtin_clzll` | Count-leading-zeros builtin not in GCC 2.95.3 |
| `__builtin_floor` / `__builtin_ceil` | Math builtins not linked on this GCC |
| `strtoll` | C99 string-to-int64 not in SCO's libc |
| `nanosleep` | POSIX high-res sleep not in SCO's libc |

## Compilation Notes

The main obstacle is that GCC 2.95.3 does not see declarations for `fchmod`, `fchown`, `readlink` and `lstat` before SQLite's static syscall table is initialised. The fix is `sco_compat.h` — a small prefix header that forces the right system headers in early:

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
```

SCO OpenServer 5 has no pthreads library so threading must be disabled. Full build command:

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
  install.sh         — installs to /usr/local (or PREFIX=$1)
  rebuild.sh         — recompiles from source with the exact working flags
```

If the binary doesn't run on a different patch level, use `rebuild.sh` to recompile — GCC 2.95.3 must be installed.

## Connecting from a Modern SSH Client

Modern OpenSSH disables the legacy algorithms that SCO's SSH daemon offers. Add this to `~/.ssh/config`:

```
Host your-sco-box
    HostName x.x.x.x
    User root
    KexAlgorithms +diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
    HostKeyAlgorithms +ssh-rsa
    PubkeyAcceptedKeyTypes +ssh-rsa
    MACs +hmac-sha1,hmac-md5
    Ciphers +aes128-cbc,aes256-cbc,3des-cbc
```
