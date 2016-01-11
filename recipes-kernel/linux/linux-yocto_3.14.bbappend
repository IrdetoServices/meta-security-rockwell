FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-3.14.4:"

SRC_URI_append_qemuarm += "file://001-MPROTECT_ported_from_grsec.patch"
