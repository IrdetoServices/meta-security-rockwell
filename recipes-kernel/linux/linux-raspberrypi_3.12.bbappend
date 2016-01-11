FILESEXTRAPATHS_prepend := "${THISDIR}/linux-raspberrypi-3.12.21:"

SRC_URI_append_rpi += "file://001-MPROTECT_ported_from_grsec.patch"
