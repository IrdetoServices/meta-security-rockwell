DESCRIPTION = "Mprotect unit test application"
SECTION = "examples"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://mprotect_test.c;md5=8250b91f36635f1c41c0dfea8c4b4b36"
PR = "r2"

SRC_URI = "file://mprotect_test.c"

S = "${WORKDIR}"

ROCKWELL_ADD_MPROTECT_EXCEPTION_${PN} = "${D}${bindir}/mprotect-test-allowed"
inherit rockwell-exception

do_compile() {
    ${CC} mprotect_test.c ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} ${LOADLIBES} ${LDLIBS} -o mprotect-test-allowed
    ${CC} mprotect_test.c ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} ${LOADLIBES} ${LDLIBS} -o mprotect-test-denied
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 mprotect-test-allowed ${D}${bindir}
    install -m 0755 mprotect-test-denied ${D}${bindir}
}

FILESEXTRAPATHS_prepend := "${THISDIR}/mprotect_test:"
