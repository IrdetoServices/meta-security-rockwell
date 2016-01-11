FILESEXTRAPATHS_prepend := "${THISDIR}/linux-raspberrypi-3.18.11:"

SRC_URI_append_raspberrypi += "file://001-MPROTECT_ported_from_grsec.patch"
