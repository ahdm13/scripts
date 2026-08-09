# Package information:
: ${name:=flex}
: ${version:=2.6.4}
: ${build:=1-main1}
: ${dists:="flex-${version}.tar.gz"}
: ${bdeps:="bison binutils gettext gcc glibc linux-headers m4 make texinfo"}

# Environment variables:
: ${jobs:=1}

build() {
	tar -xvf "flex-${version}.tar.gz"
	cd "flex-${version}"

	./configure --prefix=/usr --disable-static --docdir="/usr/share/doc/flex-${version}"
	make -j "$jobs"
	make -j "$jobs" check

	make DESTDIR="$destdir" install
	ln -sv flex   "$destdir/usr/bin/lex"
	ln -sv flex.1 "$destdir/usr/share/man/man1/lex.1"
}
