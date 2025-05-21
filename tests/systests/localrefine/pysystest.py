__pysys_title__   = r""" Mesh with local refinement """
#                        ==========================
__pysys_purpose__ = r""" Check execution of seeder and dummy executable """
    
__pysys_created__ = "2025-05-07"
#__pysys_skipped_reason__   = "Skipped until Bug-1234 is fixed"

#__pysys_traceability_ids__ = "Bug-1234, UserStory-456" 
#__pysys_groups__           = "myGroup, disableCoverage, performance"
#__pysys_modes__            = lambda helper: helper.inheritedModes + [ {'mode':'MyMode', 'myModeParam':123}, ]
#__pysys_parameterized_test_modes__ = {'MyParameterizedSubtestModeA':{'myModeParam':123}, 'MyParameterizedSubtestModeB':{'myModeParam':456}, }

import os
import pysys.basetest, pysys.mappers
from pysys.constants import *

trackfile = 'header.info'

from apes.apeshelper import ApesHelper, findTool
class PySysTest(ApesHelper, pysys.basetest.BaseTest):
    def setup(self):
        self.mkdir('mesh')
        sdrconfig = os.path.join(self.input, 'seeder.lua')
        self.copy(sdrconfig, os.path.join(self.output, 'seeder.lua'))
        self.apes.runSeeder()

    def execute(self):
        print(f'PATH={os.environ["PATH"]}')
        self.startProcess(
            findTool('dummy_exe'),
            arguments = [],
            environs = os.environ,
            stdouterr = ('dumlog.out', 'dumlog.err') )
        atlrun = self.apes.runAteles(np = 1)

    def validate(self):
        self.assertPathExists('mesh/header.lua', abortOnError = True)
        self.assertPathExists(trackfile, abortOnError = True)

