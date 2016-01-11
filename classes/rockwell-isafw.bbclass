# This is a copy of meta-security-isafw, modified to work in yocto daisy
inherit isafw

def canonical_license(d, license):
    """
    Return the canonical (SPDX) form of the license if available (so GPLv3
    becomes GPL-3.0), for the license named 'X+', return canonical form of
    'X' if availabel and the tailing '+' (so GPLv3+ becomes GPL-3.0+), 
    or the passed license if there is no canonical form.
    """
    lic = d.getVarFlag('SPDXLICENSEMAP', license, True) or ""
    if not lic and license.endswith('+'):
        lic = d.getVarFlag('SPDXLICENSEMAP', license.rstrip('+'), True)
        if lic:
            lic += '+'
    return lic or license

python isafwreport_handler () {

    import shutil
    logdir = e.data.getVar('ISAFW_LOGDIR', True)
    if os.path.exists(os.path.dirname(logdir+"/test")):
        shutil.rmtree(logdir)
    os.makedirs(os.path.dirname(logdir+"/test"))

}

# We copy and modify the method body from isafw to here to fix use of the missing 'e' in daisy
# TODO: propose a refactor patch to the isafw project and remove this modified method body

python analyse_image() {

    import re, errno

    # Directory where the image's entire contents can be examined
    rootfsdir = d.getVar('IMAGE_ROOTFS', True)

    imagebasename = d.getVar('IMAGE_BASENAME', True)

    from isafw import *
    isafw_config = isafw.ISA_config()

    isafw_config.timestamp = d.getVar('DATETIME', True)
    isafw_config.reportdir = d.getVar('ISAFW_REPORTDIR', True) + "_" + isafw_config.timestamp
    if not os.path.exists(os.path.dirname(isafw_config.reportdir + "/test")):
        try:
            os.makedirs(os.path.dirname(isafw_config.reportdir + "/test"))
        except OSError as exc:
            if exc.errno == errno.EEXIST and os.path.isdir(isafw_config.reportdir):
                pass
            else: raise
    isafw_config.logdir = d.getVar('ISAFW_LOGDIR', True)

    isafw_config.proxy = d.getVar('HTTP_PROXY', True)
    if not isafw_config.proxy :
        isafw_config.proxy = d.getVar('http_proxy', True)
    bb.debug(1, 'isafw: proxy is %s' % isafw_config.proxy)

    whitelist = d.getVar('ISAFW_PLUGINS_WHITELIST', True)
    blacklist = d.getVar('ISAFW_PLUGINS_BLACKLIST', True)
    if whitelist: 
        isafw_config.plugin_whitelist = re.split(r'[,\s]*', whitelist)
    if blacklist:
        isafw_config.plugin_blacklist = re.split(r'[,\s]*', blacklist)

    imageSecurityAnalyser = isafw.ISA(isafw_config)

    pkglist = manifest2pkglist(d)

    kernelconf = d.getVar('STAGING_KERNEL_DIR', True) + "/.config"
    
    kernel = isafw.ISA_kernel()
    kernel.img_name = imagebasename
    kernel.path_to_config = kernelconf

    bb.debug(1, 'do kernel conf analysis on %s' % kernelconf)
    imageSecurityAnalyser.process_kernel(kernel)

    pkg_list = isafw.ISA_pkg_list()
    pkg_list.img_name = imagebasename
    pkg_list.path_to_list = pkglist

    bb.debug(1, 'do pkg list analysis on %s' % pkglist)
    imageSecurityAnalyser.process_pkg_list(pkg_list)

    fs = isafw.ISA_filesystem()
    fs.img_name = imagebasename
    fs.path_to_fs = rootfsdir

    bb.debug(1, 'do image analysis on %s' % rootfsdir)
    imageSecurityAnalyser.process_filesystem(fs)
}

python warn_on_analyse_image() {
    import re, errno, fnmatch, os
    from isafw import *
    isafw_config = isafw.ISA_config()

    isafw_config.timestamp = d.getVar('DATETIME', True)
    isafw_config.reportdir = d.getVar('ISAFW_REPORTDIR', True) + "_" + isafw_config.timestamp
    if not os.path.exists(os.path.dirname(isafw_config.reportdir + "/test")):
        bb.debug( 1, 'No isafw report directory found')
        return
    for filename in os.listdir(isafw_config.reportdir) :
        if fnmatch.fnmatch(filename, 'cfa_problems_report*') :
            filename = os.path.basename(isafw_config.reportdir + "/" + filename)
            filename = os.path.splitext(filename)[0]
            filename = isafw_config.reportdir + "/" + filename
            break
    if os.path.exists(filename) :
        bb.debug(1, 'cfa_report_name is :%s' % filename)
        fileobj = open(filename, 'r')
        bb.warn('=============ISAFW CFA PROBLEMS REPORT=============\n %s' % fileobj.read())
        fileobj.close()
    else :
        bb.debug(1, 'No cfa report file found')

}

IMAGE_POSTPROCESS_COMMAND += " warn_on_analyse_image ; "
