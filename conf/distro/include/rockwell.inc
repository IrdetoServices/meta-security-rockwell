INHERIT += " rockwell-isafw "
INHERIT += " rockwell-kconf_analyzer "

require conf/distro/include/security_flags.inc

#gdbserver looks to be broken on arm with PIE
SECURITY_CFLAGS_pn-gdbserver_arm = "${SECURITY_NO_PIE_CFLAGS}"
