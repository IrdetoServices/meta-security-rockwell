DESCRIPTION = "Security flags unit test application"
SECTION = "examples"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://hello_world.c;md5=5fe3cc096dbc538a5ba81e4261d37d62"
PR = "r0"

SRC_URI = "file://hello_world.c"

S = "${WORKDIR}"

do_compile() {
    ${CC} hello_world.c ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} ${LOADLIBES} ${LDLIBS} -o rockwell_hello_world_security_flags
    ${CC} hello_world.c -o rockwell_hello_world_wo_security_flags
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 rockwell_hello_world_security_flags ${D}${bindir}
    install -m 0755 rockwell_hello_world_wo_security_flags ${D}${bindir}
}

FILESEXTRAPATHS_prepend := "${THISDIR}/test_files:"
