# Security Layer meta-security-rockwell

***meta-security-rockwell*** is an OE layer that assists developers in hardening their Yocto-built systems, focusing on the Daisy release.

Eventually, ***meta-security-rockwell*** should fail the build on security issues, requiring an explicit exemption (similar to accepting licenses). At present, security issues found in a build will be (at least) noisy. We have some work to do before we get this layer to where we want it and help is welcomed.

Currently, this layer brings together components from the following open source projects

*  [meta-security-isafw](https://github.com/01org/meta-security-isafw) -- we enable the security build flags audit (CFA) and make patches to make the isafw layer work in daisy
*  [grsec](https://grsecurity.net/) (a small piece thereof) -- we extract the MPROTECT kernel patch and add a bbclass to grant wx exceptions to applications via bitbake variables
*  the ```security_flags.inc``` file of yocto/poky -- we 'automatically' enable these within this layer

This layer also adds the following:

*  a kernel config checker which we have built around a set of hardening recommendations for Linux

## Roadmap / TODOs

Eventually, we would like this layer to support more MACHINEs and layer stack combinations, incorporate more kernel patches from the excellent grsecurity set and/or the kern-hard work that is ongoing and include configurable opt-out of the individual features of this layer.

# Using this layer

## Adding this layer to your build

1. Add this layer to your `conf/bblayers.conf` e.g.
```
BBLAYERS += "/home/awesome_dev/awesome_project/poky/meta-security-rockwell"
```
also add all of the dependent layers (see below)
2. Enable this layer's features by adding the following snippet to your `conf/local.conf`
```
require conf/distro/include/rockwell.inc
```
3. (Optional) Enable a testing build by including this layer's *testimage* features by adding the following snippet to your `conf/local.conf`
```
require conf/distro/include/rockwell-testing.inc
```

For more details on what setups this layer has been tested, please see below.

## Dependencies

This layer depends on:

  URI: git://git.yoctoproject.org/poky.git
  branch: daisy
  revision: 3d7df7b5b5c4d9293709a12396adbc38b9bf58db
  prio: default

  URI: git://git.linaro.org/openembedded/meta-linaro.git /meta-linaro-toolchain
  branch: daisy
  revision: 06008235ca752fea678953e85adaa29a491d246b
  prio: default

  URI: https://github.com/IrdetoServices/meta-raspberrypi.git
  branch: daisy-compat
  revision: 129363021fc751404b2881d41fd8d4be21eaecb3
  prio: default

  URI: https://github.com/IrdetoServices/meta-rdk-belvedere.git
  branch: daisy-compat
  revision: c05cc7f09bfaa7f51fc0d2e72b4ec9819adf7825
  prio: default

  URI: git://git.openembedded.org/meta-openembedded.git /{meta-oe, meta-networking, meta-perl}
  branch: daisy
  revision: d3d14d3fcca7fcde362cf0b31411dc4eea6d20aa
  prio: default

  URI: git://git.yoctoproject.org/meta-security.git
  branch: master
  revision: 631693cc7647410d82b7ff6a8370c2bb1a93dd07
  prio: default

  URI: https://github.com/01org/meta-security-isafw.git
  branch: jethro
  revision: d6db6a103b381aebac1a4e7dae41813aec735628
  prio: default

## Testing
This layer has been validated in the 'stack' of layers described in the 'Dependencies' section above for MACHINEs ```raspberrypi``` and ```quemuarm``` and for the image ```ccsp-test-image```. Here is also a repo manifest file capturing the collection of git checkouts used in testing, for convenience:

```
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote name="github-irdeto" fetch="https://github.com/IrdetoServices" review="" />
  <remote name="yocto" fetch="git://git.yoctoproject.org" review="" />
  <remote name="openembedded" fetch="git://git.openembedded.org" review="" />
  <remote name="linaro" fetch="git://git.linaro.org/openembedded" review="" />
  <remote name="github-01org" fetch="https://github.com/01org/" review="" />

  <default remote="yocto" revision="daisy" sync-j="4" />

  <project path="poky"
    remote="yocto" name="poky"
    revision="3d7df7b5b5c4d9293709a12396adbc38b9bf58db" /> <!-- daisy branch 20160120 -->
  <project path="poky/meta-raspberrypi"
    remote="github-irdeto" name="meta-raspberrypi"
    revision="129363021fc751404b2881d41fd8d4be21eaecb3" /> <!-- daisy-compat branch 20160120 -->
  <project path="poky/meta-rdk-belvedere"
    remote="github-irdeto" name="meta-rdk-belvedere"
    revision="c05cc7f09bfaa7f51fc0d2e72b4ec9819adf7825" /> <!-- daisy-compat branch 20160120-->
  <project path="poky/meta-openembedded"
    remote="openembedded" name="meta-openembedded"
    revision="d3d14d3fcca7fcde362cf0b31411dc4eea6d20aa" /> <!-- daisy branch 20160120 -->
  <project path="poky/meta-linaro"
    remote="linaro" name="meta-linaro"
    revision="06008235ca752fea678953e85adaa29a491d246b" /> <!-- daisy branch 20160120 -->
  <project path="poky/meta-security-rockwell"
    remote="github-irdeto" name="meta-security-rockwell"
    revision="daisy" />
  <project path="poky/meta-security"
    remote="yocto" name="meta-security"
    revision="631693cc7647410d82b7ff6a8370c2bb1a93dd07" /> <!-- master branch 20160120 -->
  <project path="poky/meta-security-isafw"
    remote="github-01org" name="meta-security-isafw"
    revision="d6db6a103b381aebac1a4e7dae41813aec735628" /> <!-- jethro branch 20160120 -->
</manifest>
```

Both MACHINEs were built with the following additions to local.conf

```
PREFERRED_VERSION_gcc                            ?= "linaro-4.8%"
PREFERRED_VERSION_gcc-cross                      ?= "linaro-4.8%"
PREFERRED_VERSION_gcc-cross-initial              ?= "linaro-4.8%"
PREFERRED_VERSION_gcc-cross-intermediate         ?= "linaro-4.8%"
PREFERRED_VERSION_gcc-cross-canadian             ?= "linaro-4.8%"
PREFERRED_VERSION_gcc-crosssdk                   ?= "linaro-4.8%"
PREFERRED_VERSION_gcc-crosssdk-initial           ?= "linaro-4.8%"
PREFERRED_VERSION_gcc-crosssdk-intermediate      ?= "linaro-4.8%"
PREFERRED_VERSION_gcc-runtime                    ?= "linaro-4.8%"
PREFERRED_VERSION_nativesdk-gcc-runtime          ?= "linaro-4.8%"
PREFERRED_VERSION_libgcc                         ?= "linaro-4.8%"
PREFERRED_VERSION_eglibc                         ?= "linaro-2.19"
PREFERRED_VERSION_nativesdk-libgcc               ?= "linaro-4.8%"
PREFERRED_VERSION_gcc-cross-canadian-${TRANSLATED_TARGET_ARCH} ?= "linaro-4.8%"
```

In the cases where the build included ```imagetest```, the following was added to ```local.conf``` before ```require conf/distro/include/rockwell-testing.inc```

```
#Yocto image tests; needs an INHERIT and also install append of dropbear or sshd since all the tests are run automatically over ssh
INHERIT += "testimage"
IMAGE_INSTALL_append = " dropbear"
#these are the suites which are compatible with the ccsp-test-image
TEST_SUITES = "ping date python rpm scp ssh syslog"
```

Furthermore, specifically for ```MACHINE=qemuarm``` the command ```bitbake ccsp-test-image -c testimage``` was invoked after building the image with ```bitbake ccsp-test-image```.

## PRs and sstate-cache

Please note that this layer contains .bbappend files which will alter the effective PR of the recipes in other layers. Please either use no sstate-cache or use a PR service along with it to ensure that the recipes are rebuilt as-needed. See the yocto project development manual for details on how to use a PR service.

# Contents and Help

## ```recipes-kernel/``` : kernel patches
Eventually the kernel patches here will contain ports of many useful kernel security features and will be available for a wide array of kernel versions and architectures.

Currently, there is a port of the excellent grsec MPROTECT feature for ```ARCH=arm kernels``` ```linux-raspberrypi-3.12.11```, ```linux-raspberrypi-3.18.11``` and ```linux-yocto-3.14.4```

NB: the MPROTECT port is an extract of a single useful feature of the grsec patchset; we do not mean to imply that using this patch is equivalent to the excellent security realized by that team when their entire patchset is applied. Using the [http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-cache/tree/features/grsec](grsec yocto kernel) feature -- for targets where it is available -- would yield a higher level of security than this patch alone and would include MPROTECT.

## ```recipes-exceptions/```and ```rockwell-exception.bbclass``` : MPROTECT exceptions at build-time
In systems with MPROTECT, it is sometime necessary to grant MPROTECT exceptions to select user space applications that need it. The ```rockwell-exception.bbclass``` provides a means to granting these exceptions by setting bitbake variables. The ```recipes-execptions``` directory contains samples demonstrating how to modify a recipe to get an exception granted at build-time.

Also here is a bbappend for paxctl_0.9 which fixes -native builds of that package.
TODO: submit the changes in this bbappend upstream as a patch to the paxctl_0.9 recipe.

## ```rockwell-mprotect.py``` : imagetest test for MPROTECT and exceptions

This yocto imagetest test (in ```lib/oeqa/runtime/rockwell-mprotect.py) verifies both the operation of MPROTECT and the build-time exception-granting mechanisms.

## ```recipes-fixes_for_security_flags/``` : recipes and patches to correct errors on ```security_flags.inc```
Here we have collected both bbappend recipe changes and patches to source code to correct errors that cropped-up when yocto/poky's ```security_flags.inc``` was enabled
TODO: submit these changes upstream to their respective projects.

## ```recipes-fixes_for_isafw_in_daisy/``` : isafw daisy compatibility##
Here we have collected bbappend files necessary to enable native and nativesdk support for a few recipes so that isafw layer can work with daisy.
TODO: submit these bbappend files to isafw project.

## ```recipes-rockwell-config-test/``` : a canary for testing isafw CFA
Here we have a recipe and source files intended to be built ignoring any ```security_flags.inc``` settings. We use this canary recipe to confirm the operation of the isafw CFA plugin by adding ```IMAGE_INSTALL_append += " security-flags-config-test "```.

## ```rockwell-isafw.bbclass``` : daisy compatible isafw fork
This is an in-tree fork of meta-security-isafw/classes/isafw.bbclass to support the daisy branch.

Currently the rockwell-isafw copies the full function body and tweaked to work with daisy branch. Added functionality to display the isafw cfa problems report as build warning output.
This is done by the module warn_on_analyse_image.
TODO: propose a refactor of isafw upstream so that an append/extend is possible here.

## ```rockwell-kconf_analyzer.bbclass``` and ```kconf_analyzer.sh``` : linux kernel config checker
This bbclass using the standalone script helps in parsing the Linux Kernel configs and warn if any of config options are not per Irdeto's Linux Hardening Guidelines.
The Warnings are saved in <build-dir>/tmp/log/kconf-*/kconf_logs and also displayed as build warning output.

## License

All files in this layer are available under the terms of the BSD 3-Clause License -- unless otherwise noted. See below, in recipes and in file headers for specific license designations.

File                                                                |License |Description
:-------------------------------------------------------------------|:------:|:----------
```├── classes```                                                   | &nbsp; | &nbsp;
```│   ├── rockwell-exception.bbclass```                            | BSD-3  | Bitbake class for granting MPROTECT exceptions
```│   ├── rockwell-isafw.bbclass```                                | MIT    | Modified version of the isafw bblcass
```│   └── rockwell-kconf_analyzer.bbclass```                       | BSD-3  | Kernel config analyser bitbake class
```├── conf```                                                      | &nbsp; | &nbsp;
```│   ├── distro```                                                | &nbsp; | &nbsp;
```│   │   └── include```                                           | &nbsp; | &nbsp;
```│   │       ├── rockwell.inc```                                  | BSD-3  | Easy include for this layer
```│   │       └── rockwell-testing.inc```                          | BSD-3  | Easy include for this layer in testing mode
```│   └── layer.conf```                                            | BSD-3  | This layer's config
```├── lib```                                                       | &nbsp; | &nbsp;
```│   └── oeqa```                                                  | &nbsp; | &nbsp;
```│       └── runtime```                                           | &nbsp; | &nbsp;
```│           ├── __init__.py```                                   | BSD-3  | MPROTECT imagetest test script
```│           └── rockwell-mprotect.py```                          | BSD-3  | MPROTECT imagetest test script
```├── README```                                                    | BSD-3  | &nbsp;
```├── recipes-exceptions```                                        | &nbsp; | &nbsp;
```│   ├── mprotect_test```                                         | &nbsp; | &nbsp;
```│   │   └── mprotect_test.c```                                   | BSD-3  | Test application for MPROTECT
```│   ├── mprotect-test_0.1.bb```                                  | BSD-3  | Test application for MPROTECT, recipe
```│   ├── mprotect-test_0.1.bbappend-test```                       | BSD-3  | Test application for MPROTECT, recipe
```│   └── paxctl_0.9.bbappend```                                   | MIT    | Overlay changes to the meta-security paxctl recipe
```├── recipes-fixes_for_isafw_in_daisy```                          | &nbsp; | &nbsp;
```│   ├── base-files_3.0.14.bbappend```                            | MIT    | Overlay changes to the poky (daisy) base-files recipe
```│   ├── bash_3.2.48.bbappend```                                  | MIT    | Overlay changes to the poky (daisy) bash recipe
```│   ├── hicolor-icon-theme_0.12.bbappend```                      | MIT    | Overlay changes to the poky (daisy) hicolor-icon-theme recipe
```│   └── json-glib_0.16.2.bbappend```                             | MIT    | Overlay changes to the poky (daisy) json-glib recipe
```├── recipes-fixes_for_security_flags```                          | &nbsp; | &nbsp;
```│   ├── ccsp-mta-agent.bbappend```                               | ASLv2  | Overlay changes to the rdk-b MTA recipe
```│   ├── ccsp-p-and-m.bbappend```                                 | ASLv2  | Overlay changes to the rdk-b P&M recipe
```│   ├── ccsp-tr069-pa.bbappend```                                | ASLv2  | Overlay changes to the rdk-b tr069 recipe
```│   ├── cve-check-tool_5.4.bbappend```                           | MIT    | Overlay changes to the isafw recipe
```│   ├── files```                                                 | &nbsp; | &nbsp;
```│   │   ├── rockwell_security_fix_ccsp-mta-agent.patch```        | ASLv2  | Patch to the rdk-b MTA sources
```│   │   ├── rockwell_security_fix_ccsp-p-and-m.patch```          | ASLv2  | Patch to the rdk-b P&M sources
```│   │   ├── rockwell_security_fix_ccsp-tr069-pa.patch```         | ASLv2  | Patch to the rdk-b tr069 sources
```│   │   ├── rockwell_security_fix_test-and-diagnostic.patch```   | ASLv2  | Patch to the rdk-b test-and-diagnostic sources
```│   │   └── rockwell_security_fix_utopia.patch```                | ASLv2  | Patch to the rdk-b utopia sources
```│   ├── test-and-diagnostic.bbappend```                          | ASLv2  | Overlay changes to the rdk-b test-and-diagnostic recipe
```│   └── utopia.bbappend```                                       | ASLv2  | Overlay changes to the rdk-b utopia recipe
```├── recipes-kernel```                                            | &nbsp; | &nbsp;
```│   └── linux```                                                 | &nbsp; | &nbsp;
```│       ├── linux-raspberrypi-3.12.21```                         | &nbsp; | &nbsp;
```│       │   └── 001-MPROTECT_ported_from_grsec.patch```          | GPL    | Linux Kernel Patch
```│       ├── linux-raspberrypi_3.12.bbappend```                   | MIT    | Overlay changes to the yocto (daisy) linux 3.12 recipe
```│       ├── linux-raspberrypi-3.18.11```                         | &nbsp; | &nbsp;
```│       │   └── 001-MPROTECT_ported_from_grsec.patch```          | GPL    | Linux Kernel Patch
```│       ├── linux-raspberrypi_3.18.bbappend```                   | MIT    | Overlay changes to the yocto (daisy) linux 3.18 recipe
```│       ├── linux-yocto-3.14.4```                                | &nbsp; | &nbsp;
```│       │   └── 001-MPROTECT_ported_from_grsec.patch```          | GPL    | Linux Kernel Patch
```│       └── linux-yocto_3.14.bbappend```                         | MIT    | Overlay changes to the yocto (daisy) linux 3.14 recipe
```├── recipes-rockwell-config-test```                              | &nbsp; | &nbsp;
```│   ├── security-flags-config-test_0.1.bb```                     | BSD-3  | Test application recipe for build flags.
```│   └── test_files```                                            | &nbsp; | &nbsp;
```│       └── hello_world.c```                                     | BSD-3  | Test application for build flags.
```└── scripts```                                                   | &nbsp; | &nbsp;
```    └── kconf_analyzer.sh```                                     | BSD-3  | Script for listing warnings of problematic kernel config options.

In summary, the patches contained in this layer are licensed according to the license of the file which they patch, bbclasses for modification of other layers are licensed according to those layers which they modify and the files for this layer itself are licensed under the BSD 3-clause license. The license body text can be found in the COPYING file under a heading matching the key in the license column in the above table. Please look there for full license details.

## Patches ##

Please submit any patches via Github pull requests at https://github.com/IrdetoServices/meta-security-rockwell

Maintainer: Ben Gardiner ben.gardiner@irdeto.com

---

grsecurity® is a registered trademark of Open Source Security, Inc.
