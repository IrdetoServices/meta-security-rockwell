INHERIT += " rockwell-isafw "
INHERIT += " rockwell-kconf_analyzer "

require conf/distro/include/security_flags.inc

#gdbserver looks to be broken on arm with PIE
SECURITY_CFLAGS_pn-gdbserver_arm = "${SECURITY_NO_PIE_CFLAGS}"

#libsigc++ breaks with the defautl SECURITY_CFLAGS on arm with PIE
SECURITY_CFLAGS_pn-libsigc++-2.0_arm = "${SECURITY_NO_PIE_CFLAGS}"

#cpufrequtils breaks with the default SECURITY_CFLAGS on arm with PIE
SECURITY_CFLAGS_pn-cpufrequtils_arm = "${SECURITY_NO_PIE_CFLAGS}"

#glibmm breaks with the default SECURITY_CFLAGS on arm with PIE
SECURITY_CFLAGS_pn-glibmm_arm = "${SECURITY_NO_PIE_CFLAGS}"

#python3 (many modules) breaks with the default SECURITY_CFLAGS on arm with PIE
SECURITY_CFLAGS_pn-python3-evdev_arm = "${SECURITY_NO_PIE_CFLAGS}"
SECURITY_CFLAGS_pn-python3-elementtree_arm = "${SECURITY_NO_PIE_CFLAGS}"
SECURITY_CFLAGS_pn-python3-subprocess_arm = "${SECURITY_NO_PIE_CFLAGS}"
SECURITY_CFLAGS_pn-python3-modules_arm = "${SECURITY_NO_PIE_CFLAGS}"
SECURITY_CFLAGS_pn-python3-xml_arm = "${SECURITY_NO_PIE_CFLAGS}"
