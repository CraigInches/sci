# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib

DESCRIPTION="Linear and non-linear least squares fitting"
HOMEPAGE="http://cpmcnet.columbia.edu/dept/gsas/biochem/labs/palmer/software/curvefit.html"
SRC_URI="http://cpmcnet.columbia.edu/dept/gsas/biochem/labs/palmer/software/curvefit.linux.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	sci-libs/blas-reference
	sys-devel/gcc:4.1"
DEPEND="dev-util/patchelf"

S="${WORKDIR}"/linux

QA_PREBUILT="opt/bin/.*"

src_install() {
	local _exe
	sed \
		-e 's: xmgr : xmgrace :g' \
		-e 's:/bin/ls:/usr/bin/ls:g' \
		-i batch_curve curveplot || die

	exeinto /opt/bin
	if use x86; then
		_exe=./linux_32/curvefit
	elif use amd64; then
		_exe=./linux_64/curvefit
	fi

	patchelf --set-rpath "${EPREFIX}/opt/${PN}:${EPREFIX}/usr/$(get_libdir)/gcc/x86_64-pc-linux-gnu/4.1.2/" ${_exe}

	doexe batch_curve curveplot ${_exe}

	dosym ../../usr/$(get_libdir)/libblas.so /opt/${PN}/libblas.so.3

	dodoc Versions
	dohtml curvefit_manual.html

	if use examples; then
		insinto /usr/share/${PN}/examples/
		doins sample*
	fi
}
