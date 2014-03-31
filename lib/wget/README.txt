This is wget for Mac OS X.

Copy:

wget into /usr/local/bin
wget.1 into /usr/local/man/man1
wgetrc into /usr/local/etc

You may need to create those directories if they don't already exist, and add /usr/local/bin to your PATH if it isn't already there.  If you'd rather not modify your PATH you can:

* call wget explicitly using /usr/local/bin/wget
* put it somewhere that *is* on your PATH, like /usr/bin.

This binary will, however, look for the system-wide configuration file wgetrc in /usr/local/etc, so it's a good idea to have that in place if you can.

I built this on Mac OS X 10.5.4.  It's version 1.11.4.

No warranties, etc... I just hope it's useful.

Quentin Stafford-Fraser
www.statusq.org
http://www.qandr.org/quentin
