KCONF_ANALYZER := " ${META_ROCKWELL_PATH}/scripts/kconf_analyzer.sh "
KCONF_LOGDIR := "${LOG_DIR}/kconf_logs"

python do_rockwell_kconf_analyze() {
    import subprocess, errno, os
    TIMESTAMP = d.getVar('DATETIME', True)
    kconf_log_dir = '${KCONF_LOGDIR}_%s' % TIMESTAMP
    if not os.path.exists(os.path.dirname(kconf_log_dir + "/test")):
         try:
             os.makedirs(os.path.dirname(kconf_log_dir + "/test"))
         except OSError as exc:
             if exc.errno == errno.EEXIST and os.path.isdir(kconf_log_dir):
                 pass
             else:
                 raise
    kconf_log_file_path = kconf_log_dir + "/kconf_logs"
    kernelconf = d.getVar('STAGING_KERNEL_DIR', True)
    kanalyzer_path = d.getVar('KCONF_ANALYZER', True)
    bb.debug(1, 'kconf path %s ' % kanalyzer_path )
    bb.debug(1, 'kernel conf path %s ' % kernelconf)
    bb.debug(1, 'kernel conf log path %s ' % os.path.dirname(kconf_log_dir))
    retval = subprocess.call("%s %s %s" % ( kanalyzer_path, kernelconf, kconf_log_file_path ), shell=True )
    if retval != 0 :
        fileobj = open(kconf_log_file_path, 'r')
        bb.warn('===========Kconf Analyzer Report=============\n%s\n\nWarnings from kconf analyzer: %s' % (fileobj.read(), retval))
        fileobj.close()
}

IMAGE_POSTPROCESS_COMMAND += " do_rockwell_kconf_analyze ; "
