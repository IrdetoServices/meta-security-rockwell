import unittest
from oeqa.oetest import oeRuntimeTest, skipModule
from oeqa.utils.decorators import *

def setUpModule():
    if not oeRuntimeTest.hasPackage("syslog"):
        skipModule("No syslog package in image")

class MprotectTest(oeRuntimeTest):

    @skipUnlessPassed("test_ssh")
    def test_mprotect_wx_allowed_when_exception(self):
        (status,output) = self.target.run('/usr/bin/mprotect-test-allowed')
        self.assertEqual(status, 0, msg="status and output %s and %s" % (status,output))

    @skipUnlessPassed("test_ssh")
    def test_mprotect_wx_denied(self):
        (status,output) = self.target.run('/usr/bin/mprotect-test-denied')
        self.assertNotEqual(status, 0, msg="status and output %s and %s" % (status,output))

