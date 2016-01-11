ROCKWELL_ADD_MPROTECT_EXCEPTION_${PN} ?= ""
PAXCTL = "paxctl"
ROCKWELL_EXP_MPROTECT_FILE_NAME = "${ROCKWELL_ADD_MPROTECT_EXCEPTION_${PN}}"

do_mprotect_exception[depends] += "paxctl-native:do_populate_sysroot"

do_mprotect_exception() {
    if [ ${ROCKWELL_EXP_MPROTECT_FILE_NAME} != "" ] ; then
        # Do we have a paxctl?
        if [ -e ${PAXCTL} ]; then
            echo "- A valid paxctl must be specified"
            exit 1
        fi

        # Does file exists?
        if [ ! -e ${ROCKWELL_EXP_MPROTECT_FILE_NAME} ]; then
            echo "- File does not exists : $ROCKWELL_EXP_MPROTECT_FILE_NAME"
            exit 1
        fi

        # Add PT_PAX_FLAGS ELF header section
        ${PAXCTL} -c ${ROCKWELL_EXP_MPROTECT_FILE_NAME}

        if [ "$?" != "0" ]; then
            echo "- Failed to add PT_PAX_FLAGS ELF header section"
            exit 1
        fi

        # Disable PAGEEXEC, PAGEEXEC and MPROTECT
        ${PAXCTL} -p -s -m ${ROCKWELL_EXP_MPROTECT_FILE_NAME}

        if [ "$?" != "0" ]; then
            echo "- Failed to disable mprotect hardening"
            exit 1
        fi
        exit 0

        # (debug) Display PT_PAX_FLAGS flags
        set -x
        ${PAXCTL} -v ${ROCKWELL_EXP_MPROTECT_FILE_NAME}

        if [ "$?" != "0" ]; then
            echo "- Failed to query PT_PAX_FLAGS flags"
            exit 1
        fi
    fi
}

addtask mprotect_exception after do_install before do_package do_populate_sysroot

