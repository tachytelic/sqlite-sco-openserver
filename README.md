# SCO OpenServer Precompiled Binaries

Precompiled binaries for SCO OpenServer 5, maintained by [Paul Murana](https://tachytelic.net/2017/07/sco-openserver-stuff/) at Accendo Solutions Ltd.

I work with SCO OpenServer 5 systems regularly and compile these tools to make it quicker to get them onto systems I'm working on. Full background on the [blog post](https://tachytelic.net/2017/07/sco-openserver-stuff/).

## Downloads

Go to the [Releases](../../releases) page to download precompiled tarballs. Each release includes an `install.sh` script that copies the binary and headers to `/usr/local`.

## Binaries

| Binary | Version | Notes |
|---|---|---|
| [SQLite](sqlite-3.39.4/) | 3.39.4 | Latest version compilable with GCC 2.95.3 |
| [Bash](bash-3.2.57/) | 3.2.57 | Includes patches for ShellShock vulnerability |
| [rsync](rsync-3.1.2/) | 3.1.2 | |
| [GNU Tar](tar-1.16.1/) | 1.16.1 | |
| [wget](wget-1.10/) | 1.10 | Without SSL support — use curl for HTTPS |
| [lzop](lzop-1.04/) | 1.04 | Requires `rm` from GNU tools |
| [Python](python-2.7.18/) | 2.7.18 | Final ever release of Python 2 (EOL January 2020) |

## Compilation Environment

Unless otherwise noted, binaries are compiled on SCO OpenServer 5.0.6 and tested on 5.0.7, with the following supplements installed:

- Release Supplement 5.0.6A for OpenServer 5
- Support Level Supplement (SLS) OSS646C
- OpenServer 5.0.7 GNU Development Tools supplement
- OpenServer Supplemental Graphics, Web and X11 Libraries supplement

## Connecting from a Modern SSH Client

Modern OpenSSH disables the legacy algorithms that SCO's SSH daemon offers. Add this to your `~/.ssh/config` to avoid negotiation failures:

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

## Contributing

If you have compiled something useful for SCO OpenServer 5 and want to add it, open an issue or a pull request.
