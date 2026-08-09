# Package information:
: ${name:=m4}
: ${version:=1.4.21}
: ${build:=1-main1}
: ${dists:="m4-${version}.tar.xz"}
: ${bdeps:="binutils gcc glibc linux-headers make"}

# Environment variables:
: ${jobs:=1}

build() {
	tar -xvf "m4-${version}.tar.xz"
	cd "m4-${version}"

	./configure --prefix=/usr
	make -j "$jobs"
	make -j "$jobs" check
	make DESTDIR="$destdir" install
}
