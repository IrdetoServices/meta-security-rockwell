# NB: set TEST_SUITES before including this file
# if testimage is enabled, then require'ing this file will add the meta-security-rockwell testimage tests to the suite

TEST_SUITES += "rockwell-mprotect"
IMAGE_INSTALL_append += " mprotect-test "

