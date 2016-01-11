#!/bin/bash

KBUILD="${1}"
LOG_PATH="${2}"

if [ ! -d "${KBUILD}" ] || [ ! -d "$(dirname "${LOG_PATH}")" ]; then
	echo "usage: $0 <kernel build dir> <log output>" > /dev/stderr
	exit 1
fi

echo "running kconf check" > /dev/stderr
echo "kernel build dir: ${KBUILD}" > /dev/stderr
echo "kconf check log output: ${LOG_PATH}" > /dev/stderr

warnings=0
warn() {
	echo "$@" >> ${LOG_PATH} 
	warnings=$(( ${warnings} + 1 ))
}

conf_grep() {
	cat "${KBUILD}/.config" | grep -q "${1}"
}

test_conf_is_set() {
	conf_grep "CONFIG_${1}="
}

test_conf_not_set() {
	if test_conf_is_set ${1}; then
		return 1
	else
		return 0
	fi
}

check_DEBUG_INFO() {
	if test_conf_not_set DEBUG_INFO; then
		return
	fi

	warn "DEBUG_INFO: Debug symbols should always be removed from production kernels as they provide a lot of information to attackers"

	if test_conf_not_set DEBUG_INFO_REDUCED; then
		return
	fi
	warn "DEBUG_INFO_REDUCED: if DEBUG_INFO must be set, then DEBUG_INFO_REDUCED should be set to reduce the impact of the former"
}

check_CROSS_MEMORY_ATTACH() {
	if test_conf_not_set CROSS_MEMORY_ATTACH; then
		return
	fi

	warn "CROSS_MEMORY_ATTACH: can be useful to attackers in inspecting and modifying running processes"
}

check_KGDB() {
	if test_conf_not_set KGDB; then
		return
	fi

	warn "KGDB: enables an in-kernel debugger for use by anyone with root or physical access (including attackers to great effect)"
}

check_OMAP_FIQ_DEBUGGER() {
	if test_conf_is_set OMAP_FIQ_DEBUGGER; then
		warn "OMAP_FIQ_DEBUGGER: enables an in-kernel debugger for use by anyone with physical access (including attackers to great effect)"
	fi
}

check_MAGIC_SYSRQ() {
	if test_conf_not_set MAGIC_SYSRQ; then
		return
	fi

	warn "MAGIC_SYSRQ: enables a useful debugging aid for console (inclusing serial) access"
}

check_MODULE_UNLOAD() {
	if test_conf_not_set MODULE_UNLOAD; then
		return
	fi

	warn "MODULE_UNLOAD: enables code paths for module unloading which are rarely excersized in practice and can be an attractive target for attackers seeking to exploit the kernel"
}

check_AUDITSYSCALL() {
	if test_conf_not_set AUDITSYSCALL; then
		return
	fi

	warn "AUDITSYSCALL: exposes the runtime operation of services to an attacker"
}

check_DEBUG_RODATA(){
	if test_conf_is_set DEBUG_RODATA; then
		return
	fi

	warn "DEBUG_RODATA: marks immutable sections in the kernel as non-writable and should be enabled to thwart some kernel data attacks"
}

check_DEBUG_SET_MODULE_RONX() {
	if test_conf_is_set DEBUG_SET_MODULE_RONX; then
		return
	fi

	warn "DEBUG_SET_MODULE_RONX: marks module data sections as NX and immutable sections as RO and should be enabled to thwart some kernel attacks"
}

check_KPROBES() {
	if test_conf_not_set KPROBES; then
		return
	fi

	warn "KPROBES: exposes the runtime operation of services and the kernel to an attacker"
}

check_FTRACE() {
	if test_conf_not_set FTRACE; then
		return
	fi

	warn "FTRACE: exposes the runtime operation of services to an attacker"
}

check_OPROFILE() {
	if test_conf_not_set OPROFILE; then
		return
	fi

	warn "OPROFILE: exposes the runtime operation of services to an attacker"
}

check_PROFILING() {
	if test_conf_not_set PROFILING; then
		return
	fi

	warn "PROFILING: exposes the runtime operation of services to an attacker and also triggers inclusion of more debugging information into the kernel image"
}

check_BPF_JIT() {
	if test_conf_not_set BPF_JIT; then
		return
	fi

	warn "BPF_JIT: enables a compiler in the kernel which can be exploited for kernel space payloads"
}

check_COREDUMP() {
	if test_conf_not_set COREDUMP; then
		return
	fi

	warn "COREDUMP: enables useful (to attackers) core files on crashes"
}

check_IKCONFIG() {
	if test_conf_not_set IKCONFIG; then
		return
	fi

	warn "IKCONFIG: enables a /proc file from which all kernel config can be dumped, providing useful information to attackers"
}

check_CHECKPOINT_RESTORE() {
	if test_conf_not_set CHECKPOINT_RESTORE; then
		return
	fi

	warn "CHECKPOINT_RESTORE: enables writing a file more useful (to attackers) than a core dump"
}

check_CC_STACKPROTECTOR() {
	if test_conf_is_set CC_STACKPROTECTOR; then
		return
	fi

	warn "CC_STACKPROTECTOR: should be enabled to build the kernel with stack-smashing protections"
}

check_FW_LOADER_USER_HELPER() {
	if test_conf_not_set FW_LOADER_USER_HELPER; then
		return
	fi

	warn "FW_LOADER_USER_HELPER: uses a setuid helper binary executed on hotplug events. It is an attactive target to attackers with physical control of the ports on a device"
}

check_STRICT_DEVMEM() {
	if test_conf_is_set STRICT_DEVMEM; then
		return
	fi

	warn "STRICT_DEVMEM: (when available in the kernel version) provides some marginal protections against attackers gaining unfettered access to system memory"
}

check_DEVKMEM() {
	if test_conf_not_set DEVKMEM; then
		return
	fi

	warn "DEVKMEM: the /dev/kmem device is rarely used by applications in userspace; when enabled it gives attackers a (slightly) more useful view into kernel memory than /dev/mem"
}

check_DEBUG_BUGVERBOSE() {
	if test_conf_not_set DEBUG_BUGVERBOSE; then
		return
	fi

	warn "DEBUG_BUGVERBOSE: when enabled will cause lots of useful stack information to be printed to the console; disable this to make attackers lives more difficult"
}

check_KEXEC() {
	if test_conf_not_set KEXEC; then
		return
	fi

	warn "KEXEC: gives attackers interesting means to substitute kernels"
}

check_PACKET_DIAG() {
	if test_conf_not_set PACKET_DIAG; then
		return
	fi

	warn "PACKET_DIAG: packet monitoring can be used to inspect localhost traffic which is otherwise assumed to be confidential"
}

check_UNIX_DIAG() {
	if test_conf_not_set UNIX_DIAG; then
		return
	fi

	warn "UNIX_DIAG: unix domain socket monitoring can be used to inspect shared file descriptors and other traffic which is otherwise assumed to be confidential"
}

check_IP_PNP() {
	if test_conf_not_set IP_PNP; then
		return
	fi

	warn "IP_PNP: enables kernel-level autoconfiguration of IP interfaces, disable this and rely on userspace tools where privs are separated and overflows don't compromise the kernel"
}

check_SWAP() {
	if test_conf_not_set SWAP; then
		return
	fi

	warn "SWAP: attackers can enable swap at runtime, add pressure to the memory subsystem and then scour the pages written to swap for useful information"
}

check_NAMESPACES() {
	if test_conf_not_set NAMESPACES; then
		return
	fi

	warn "NAMESPACES: enabling this can result in duplicates of dev nodes, pids and mount points which can be useful to attackers trying to spoof running environments on devices."
}

check_NFSD() {
	if test_conf_not_set NFSD; then
		return
	fi

	warn "NFSD: can be a very useful way for an attacker to get files onto a device"
}

check_NFS_FS() {
	if test_conf_not_set NFS_FS; then
		return
	fi

	warn "NFS_FS: can be a very useful way for an attacker to get files onto a device"
}

check_BINFMT_MISC() {
	if test_conf_not_set BINFMT_MISC; then
		return
	fi

	warn "BINFMT_MISC: enables code paths not so frequently tested and should be disabled if possible"
}

check_BINFMT_AOUT() {
	if test_conf_not_set BINFMT_AOUT; then
		return
	fi

	warn "BINFMT_AOUT: enables code paths not so frequently tested and should be disabled if possible"
}

check_USELIB() {
	if test_conf_not_set USELIB; then
		return
	fi

	warn "USELIB: enables code paths not so frequently tested and should be disabled"
}

check_DEBUG_FS() {
	if test_conf_not_set DEBUG_FS; then
		return
	fi

	warn "DEBUG_FS: this filesystem provides alot of useful information and means of manipulation to an attacker"
}

check_MODULES() {
	if test_conf_not_set MODULES; then
		return
	fi

	warn "MODULES: if disabled then there is a large impediment to attackers loading code into the kernel -- in most systems, however, this cannot be disabled; consider using module signing"
}

check_MODULE_SIG_FORCE() {
	if test_conf_is_set MODULE_SIG_FORCE; then
		return
	fi

	warn "MODULE_SIG_FORCE: when set, significantly raises the bar of preventing attackers from loading malicious kernel code via loadable modules"
}

check_MODULE_FORCE_LOAD() {
	if test_conf_not_set MODULE_FORCE_LOAD; then
		return
	fi

	warn "MODULE_FORCE_LOAD: when set, makes it simpler for attackers to insert modules that have not been built againts the specific kernel version and config deployed on the device"
}

check_PANIC_ON_OOPS() {
	if test_conf_is_set PANIC_ON_OOPS; then
		return
	fi

	warn "PANIC_ON_OOPS: when set, any BUGS or other violations in kernel runtime will result in a PANIC (which will in turn result in a reboot with kernel command line panic=reboot). This can impede attackers attempt to craft exploits for kernelspace"
}

check_KALLSYMS_ALL() {
	if test_conf_not_set KALLSYMS_ALL; then
		return
	fi

	warn "KALLSYMS_ALL: enables *all* kernel symbols in the /proc/kallsyms file which can be most useful to attackers in characterising a kernel's version, configuration and more generally its disposition to attacks"
}

check_KALLSYMS() {
	if test_conf_not_set KALLSYMS; then
		return
	fi

	warn "KALLSYMS: enables kernel symbols in the /proc/kallsysms file which can be most useful to attackers in characterising a kernel's version, configuration and more generally its disposition to attacks"
}

check_ARM_UNWIND() {
	if test_conf_not_set ARM_UNWIND; then
		return
	fi

	warn "ARM_UNWIND: enables friendly backtraces on ARM architechtures, making attackers lives easier. (ignore this warning on ARCHs other than ARM)"
}

check_DEBUG_USER() {
	if test_conf_not_set DEBUG_USER; then
		return
	fi

	warn "DEBUG_USER: enabled friendly backtraces for userspace programs that crash, making exploit development of userspace apps easier for attackers (relative to coredumps disabled)"
}

check_BUG() {
	if test_conf_not_set BUG; then
		return
	fi

	warn "BUG: enables backtraces and register information on BUGs or WARNs in the kernel, making kernel exploit development easier for attackers"
}

check_SYSCTL_SYSCALL() {
	if test_conf_not_set SYSCTL_SYSCALL; then
		return
	fi

	warn "SYSCTL_SYSCALL: enabling this results in code being included that is purportedly hard to maintain and is also thus not well tested"
}

check_DEBUG_KERNEL() {
	if test_conf_not_set DEBUG_KERNEL; then
		return
	fi

	warn "DEBUG_KERNEL: enables some useful (to attackers) sysfs files. In some kernel versions, disabling this requires also disabling EMBEDDED which prevents disabling COREDUMP, DEBUG_BUGVERBOSE, NAMESPACES, MODULES, KALLSYMS and BUG. In which case it is better to leave this enabled than enbale the others"
}
check_PROC_KCORE() {
	if test_conf_not_set PROC_KCORE; then
		return
	fi

	warn "PROC_KCORE: enables access to a kernel core dump from userspace; if enabled it gives attackers a useful view into kernel memory"
}

check_FUSE_FS() {
	if test_conf_is_set FUSE_FS; then
		return
	fi

	warn "FUSE_FS: enabling this and further configuring your system to mount hotplug media filesystems through FUSE reduces the attack surface of the kernel for attackers with control of the physical ports of the device."
}

check_SECURITY() {
	if test_conf_is_set SECURITY; then
		return
	fi

	warn "SECURITY: enabling this and further selecting a non-DAC LSM (e.g. SELinux, SMACK) and deploying a non permissive policy for that LSM can impede an attackers progress should a process get compromised."
}

check_DEBUG_INFO
check_CROSS_MEMORY_ATTACH
check_KGDB
check_OMAP_FIQ_DEBUGGER
check_MAGIC_SYSRQ
check_MODULE_UNLOAD
check_AUDITSYSCALL
check_DEBUG_RODATA
check_DEBUG_SET_MODULE_RONX
check_KPROBES
check_FTRACE
check_OPROFILE
check_PROFILING
check_BPF_JIT
check_COREDUMP
check_IKCONFIG
check_CHECKPOINT_RESTORE
check_CC_STACKPROTECTOR
check_FW_LOADER_USER_HELPER
check_STRICT_DEVMEM
check_DEVKMEM
check_DEBUG_BUGVERBOSE
check_KEXEC
check_PACKET_DIAG
check_UNIX_DIAG
check_IP_PNP
check_SWAP
check_NAMESPACES
check_NFSD
check_NFS_FS
check_BINFMT_MISC
check_BINFMT_AOUT
check_USELIB
check_DEBUG_FS
check_MODULES
check_MODULE_SIG_FORCE
check_MODULE_FORCE_LOAD
check_PANIC_ON_OOPS
check_KALLSYMS_ALL
check_KALLSYMS
check_ARM_UNWIND
check_DEBUG_USER
check_BUG
check_SYSCTL_SYSCALL
check_DEBUG_KERNEL
check_PROC_KCORE
check_FUSE_FS
check_SECURITY

echo "KConf warnings total: ${warnings}"

exit "${warnings}"
