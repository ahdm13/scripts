# Package information:
: ${name:=tcl}
: ${version:=8.6.17}
: ${version_major:=8.6}
: ${build:=1-main1}
: ${dists:="tcl${version}-src.tar.gz"}
: ${bdeps:="binutils gcc glibc linux-headers make"}

# Environment variables:
: ${jobs:=1}
: ${tests=NO}

build() {
	tar -xvf "tcl${version}-src.tar.gz"
	cd "tcl${version}"

	SRCDIR=`pwd`
	cd unix
	./configure --prefix=/usr --mandir=/usr/share/man --disable-rpath

	make -j "$jobs"
	sed -e "s|$SRCDIR/unix|/usr/lib|"    \
		-e "s|$SRCDIR|/usr/include|" \
		-i tclConfig.sh

	sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.12|/usr/lib/tdbc1.1.12|"    \
		-e "s|$SRCDIR/pkgs/tdbc1.1.12/generic|/usr/include|"    \
		-e "s|$SRCDIR/pkgs/tdbc1.1.12/library|/usr/lib/tcl8.6|" \
		-e "s|$SRCDIR/pkgs/tdbc1.1.12|/usr/include|"            \
		-i pkgs/tdbc1.1.12/tdbcConfig.sh

	sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.4|/usr/lib/itcl4.3.4|"  \
		-e "s|$SRCDIR/pkgs/itcl4.3.4/generic|/usr/include|" \
		-e "s|$SRCDIR/pkgs/itcl4.3.4|/usr/include|"         \
		-i pkgs/itcl4.3.4/itclConfig.sh

	unset SRCDIR

	if [ "$tests" = YES ]; then
		LC_ALL=C.UTF-8 make -j "$jobs" test
	fi
	make DESTDIR="$destdir" install
	chmod 644 "$destdir/usr/lib/libtclstub${version_major}.a"
	chmod -v u+w "$destdir/usr/lib/libtcl${version_major}.so"

	make DESTDIR="$destdir" install-private-headers
	ln -sfv "tclsh${version_major}" "$destdir/usr/bin/tclsh"
	mv -v "$destdir/usr/share/man/man3/Thread.3" "$destdir/usr/share/man/man3/Tcl_Thread.3"
}
