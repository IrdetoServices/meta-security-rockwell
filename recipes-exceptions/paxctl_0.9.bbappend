BBCLASSEXTEND = "native nativesdk"

DEPENDS_append = " virtual/fakeroot-native "

fakeroot do_install () {
    oe_runmake 'DESTDIR=${D}${base_prefix}' install
}

