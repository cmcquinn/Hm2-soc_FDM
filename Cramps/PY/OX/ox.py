# HAL file for mksocfpga and 3D printer board
import os

from machinekit import rtapi as rt
from machinekit import hal
from machinekit import config as c

from fdm.config import base
from fdm.config import storage
from fdm_local.config import motion
import cramps as hardware

# initialize the RTAPI command client
rt.init_RTAPI()
# loads the ini file passed by linuxcnc
c.load_ini(os.environ['INI_FILE_NAME'])

motion.setup_motion()
#hardware.init_hardware()
storage.init_storage('storage.ini')

# Gantry components for Y Axis
base.init_gantry(axisIndex=1)

# reading functions
hardware.hardware_read()
base.gantry_read(gantryAxis=1, thread='servo-thread')
hal.addf('motion-command-handler', 'servo-thread')

#numFans = c.find('FDM', 'NUM_FANS')
#numLights = c.find('FDM', 'NUM_LIGHTS')

# Axis-of-motion Specific Configs (not the GUI)

# X [0] Axis
base.setup_stepper(section='AXIS_0', axisIndex=0, stepgenIndex=0, stepgenType='hm2_5i25.0.stepgen')
# Y [1] Axis
base.setup_stepper(section='AXIS_1', axisIndex=1, stepgenIndex=1, stepgenType='hm2_5i25.0.stepgen',
              thread='servo-thread', gantry=True, gantryJoint=0)
base.setup_stepper(section='AXIS_1', axisIndex=1, stepgenIndex=2, stepgenType='hm2_5i25.0.stepgen',
            gantry=True, gantryJoint=1)
# Z [2] Axis
base.setup_stepper(section='AXIS_2', axisIndex=2, stepgenIndex=3, stepgenType='hm2_5i25.0.stepgen')

# Fans
#for i in range(0, numFans):
#for i in range(0, numFans):
#    base.setup_fan('f%i' % i, thread='servo-thread')
#for i in range(0, numExtruders):
#    hardware.setup_exp('exp%i' % i)

# LEDs
#for i in range(0, numLights):
#    base.setup_light('l%i' % i, thread='servo-thread')

# Standard I/O - EStop, Enables, Limit Switches, Etc
#errorSignals = ['watchdog-error']
errorSignals = []
#for i in range(0, numExtruders):
#    errorSignals.append('e%i-error' % i)
#base.setup_estop(errorSignals, thread='servo-thread')
base.setup_estop(errorSignals, thread='servo-thread')
base.setup_tool_loopback()
# Probe
base.setup_probe(thread='servo-thread')
# Setup Hardware
hardware.setup_hardware(thread='servo-thread')

# write out functions
hal.addf('motion-controller', 'servo-thread')
base.gantry_write(gantryAxis=1, thread='servo-thread')
hardware.hardware_write()

# Storage
storage.read_storage()

# start haltalk server after everything is initialized
# else binding the remote components on the UI might fail
hal.loadusr('haltalk', wait=True)
