# HAL file for Trinamic SPI configuration
import os
from machinekit import hal
from machinekit import rtapi as rt
from machinekit import config as c
#from fdm.config import motion
from fdm_local.config import motion
from fdm.config import base
import cramps as hardware

hal.epsilon[1] = 0.1

# initialize the RTAPI command client
rt.init_RTAPI()
# loads the ini file passed by linuxcnc
c.load_ini(os.environ['INI_FILE_NAME'])

motion.setup_motion()

# reading functions
hardware.hardware_read()
hal.addf('motion-command-handler', 'servo-thread')

# Axis-of-motion Specific Configs (not the GUI)

# X [0] Axis
base.setup_stepper(section='AXIS_0', axisIndex=0, stepgenIndex=0, stepgenType='hm2_5i25.0.stepgen')

# Standard I/O - EStop, Enables, Limit Switches, Etc
#errorSignals = ['watchdog-error']
errorSignals = []
#for i in range(0, numExtruders):
#    errorSignals.append('e%i-error' % i)
#base.setup_estop(errorSignals, thread='servo-thread')
base.setup_estop(errorSignals, thread='servo-thread')
base.setup_tool_loopback()
# Probe
#base.setup_probe(thread='servo-thread')
# Setup Hardware
hardware.setup_hardware(thread='servo-thread')

# write out functions
hal.addf('motion-controller', 'servo-thread')
hardware.hardware_write()

# trinamic_dbspi component:  ---------------------------------------------------------------------#
rt.loadrt('trinamic_dbspi', dbspi_chans='hm2_5i25.0.dbspi.0')
trinamicdbspi = hal.Component('trinamic-dbspi.0')

# create the signals for connecting the components
drvctrl  = hal.newsig('drvctrl-reg-unsigned',  hal.HAL_U32)
chopconf = hal.newsig('chopconf-reg-unsigned', hal.HAL_U32)
smarten  = hal.newsig('smarten-reg-unsigned',  hal.HAL_U32)
sgcsconf = hal.newsig('sgcsconf-reg-unsigned', hal.HAL_U32)
drvconf  = hal.newsig('drvconf-reg-unsigned',  hal.HAL_U32)

fullval_0  = hal.newsig('full-val-0-unsigned', hal.HAL_U32)
fullval_1  = hal.newsig('full-val-1-unsigned', hal.HAL_U32)
fullval_2  = hal.newsig('full-val-2-unsigned', hal.HAL_U32)
fullval_3  = hal.newsig('full-val-3-unsigned', hal.HAL_U32)
fullval_4  = hal.newsig('full-val-4-unsigned', hal.HAL_U32)
fullval_5  = hal.newsig('full-val-5-unsigned', hal.HAL_U32)
sgreadout  = hal.newsig('sg-readout-float',  hal.HAL_FLOAT)
stststatus = hal.newsig('stst-status-bit',   hal.HAL_BIT)
olbstatus  = hal.newsig('olb-status-bit',    hal.HAL_BIT)
olastatus  = hal.newsig('ola-status-bit',    hal.HAL_BIT)
s2gbstatus = hal.newsig('s2gb-status-bit',   hal.HAL_BIT)
s2gastatus = hal.newsig('s2ga-status-bit',   hal.HAL_BIT)
otpwstatus = hal.newsig('otpw-status-bit',   hal.HAL_BIT)
otstatus   = hal.newsig('ot-status-bit',     hal.HAL_BIT)
sgstatus   = hal.newsig('sg-status-bit',     hal.HAL_BIT)

intpol = hal.newsig('intpol-set-bit', hal.HAL_BIT)
dedge  = hal.newsig('dedge-set-bit', hal.HAL_BIT)
mres = hal.newsig('mres-set-signed', hal.HAL_FLOAT)

tbl = hal.newsig('tbl-set-unsigned', hal.HAL_FLOAT)
chm = hal.newsig('chm-set-bit', hal.HAL_BIT)
rndtf = hal.newsig('rndtf-set-bit', hal.HAL_BIT)
hdec1 = hal.newsig('hdec1-set-bit', hal.HAL_BIT)
hdec0 = hal.newsig('hdec0-set-bit', hal.HAL_BIT)
hend = hal.newsig('hend-set-unsigned', hal.HAL_FLOAT)
hstrt = hal.newsig('hstrt-set-unsigned', hal.HAL_FLOAT)
toff = hal.newsig('toff-set-unsigned', hal.HAL_FLOAT)

seimin = hal.newsig('seimin-set-bit', hal.HAL_BIT)
sedn = hal.newsig('sedn-set-unsigned', hal.HAL_FLOAT)
semax = hal.newsig('semax-set-unsigned', hal.HAL_FLOAT)
seup = hal.newsig('seup-set-unsigned', hal.HAL_FLOAT)
semin = hal.newsig('semin-set-unsigned', hal.HAL_FLOAT)

sfilt = hal.newsig('sfilt-set-bit', hal.HAL_BIT)
sgt = hal.newsig('sgt-set-signed', hal.HAL_FLOAT)
cs = hal.newsig('cs-set-unsigned', hal.HAL_FLOAT)

tst = hal.newsig('tst-set-bit', hal.HAL_BIT)
slph = hal.newsig('slph-set-unsigned', hal.HAL_FLOAT)
slpl = hal.newsig('slpl-set-unsigned', hal.HAL_FLOAT)
diss2g = hal.newsig('diss2g-set-bit', hal.HAL_BIT)
ts2g = hal.newsig('ts2g-set-unsigned', hal.HAL_FLOAT)
sdoff = hal.newsig('sdoff-set-bit', hal.HAL_BIT)
vsense = hal.newsig('vsense-set-bit', hal.HAL_BIT)
rdsel = hal.newsig('rdsel-set-unsigned', hal.HAL_FLOAT)



error = hal.newsig('error-signal', hal.HAL_BIT)

# create trinamic_dbspi component pins
trinamicdbspi.pin('drvctrl.reg').link(drvctrl)
trinamicdbspi.pin('chopconf.reg').link(chopconf)
trinamicdbspi.pin('smarten.reg').link(smarten)
trinamicdbspi.pin('sgcsconf.reg').link(sgcsconf)
trinamicdbspi.pin('drvconf.reg').link(drvconf)

trinamicdbspi.pin('full.0.val').link(fullval_0)
trinamicdbspi.pin('full.1.val').link(fullval_1)
trinamicdbspi.pin('full.2.val').link(fullval_2)
trinamicdbspi.pin('full.3.val').link(fullval_3)
trinamicdbspi.pin('full.4.val').link(fullval_4)
trinamicdbspi.pin('sg.readout').link(sgreadout)
trinamicdbspi.pin('stst.status').link(stststatus)
trinamicdbspi.pin('olb.status').link(olbstatus)
trinamicdbspi.pin('ola.status').link(olastatus)
trinamicdbspi.pin('s2gb.status').link(s2gbstatus)
trinamicdbspi.pin('s2ga.status').link(s2gastatus)
trinamicdbspi.pin('otpw.status').link(otpwstatus)
trinamicdbspi.pin('ot.status').link(otstatus)
trinamicdbspi.pin('sg.status').link(sgstatus)

trinamicdbspi.pin('intpol.set').link(intpol)
trinamicdbspi.pin('dedge.set').link(dedge)
trinamicdbspi.pin('mres.set').link(mres)

trinamicdbspi.pin('tbl.set').link(tbl)
trinamicdbspi.pin('chm.set').link(chm)
trinamicdbspi.pin('rndtf.set').link(rndtf)
trinamicdbspi.pin('hdec1.set').link(hdec1)
trinamicdbspi.pin('hdec0.set').link(hdec0)
trinamicdbspi.pin('hend.set').link(hend)
trinamicdbspi.pin('hstrt.set').link(hstrt)
trinamicdbspi.pin('toff.set').link(toff)

trinamicdbspi.pin('seimin.set').link(seimin)
trinamicdbspi.pin('sedn.set').link(sedn)
trinamicdbspi.pin('semax.set').link(semax)
trinamicdbspi.pin('seup.set').link(seup)
trinamicdbspi.pin('semin.set').link(semin)

trinamicdbspi.pin('sfilt.set').link(sfilt)
trinamicdbspi.pin('sgt.set').link(sgt)
trinamicdbspi.pin('cs.set').link(cs)

trinamicdbspi.pin('tst.set').link(tst)
trinamicdbspi.pin('slph.set').link(slph)
trinamicdbspi.pin('slpl.set').link(slpl)
trinamicdbspi.pin('diss2g.set').link(diss2g)
trinamicdbspi.pin('ts2g.set').link(ts2g)
trinamicdbspi.pin('sdoff.set').link(sdoff)
trinamicdbspi.pin('vsense.set').link(vsense)
trinamicdbspi.pin('rdsel.set').link(rdsel)


# create remote component
rcomp = hal.RemoteComponent('TrinamicSPI', timer=100)
rcomp.newpin('drvctrl.reg', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('chopconf.reg', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('smarten.reg', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('sgcsconf.reg', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('drvconf.reg', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('full.0.val', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('full.1.val', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('full.2.val', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('full.3.val', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('full.4.val', hal.HAL_U32, hal.HAL_IN)
rcomp.newpin('sg.readout', hal.HAL_FLOAT, hal.HAL_IN, eps=1)
rcomp.newpin('stst.status', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('olb.status', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('ola.status', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('s2gb.status', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('s2ga.status', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('otpw.status', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('ot.status', hal.HAL_BIT, hal.HAL_IN)
rcomp.newpin('sg.status', hal.HAL_BIT, hal.HAL_IN)

rcomp.newpin('intpol.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('dedge.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('mres.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)

rcomp.newpin('tbl.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
rcomp.newpin('chm.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('rndtf.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('hdec1.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('hdec0.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('hend.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
rcomp.newpin('hstrt.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
rcomp.newpin('toff.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)

rcomp.newpin('seimin.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('sedn.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
rcomp.newpin('semax.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
rcomp.newpin('seup.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
rcomp.newpin('semin.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)

rcomp.newpin('sfilt.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('sgt.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
rcomp.newpin('cs.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)

rcomp.newpin('tst.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('slph.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
rcomp.newpin('slpl.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
rcomp.newpin('diss2g.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('ts2g.set', hal.HAL_FLOAT, hal.HAL_IO)
rcomp.newpin('sdoff.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('vsense.set', hal.HAL_BIT, hal.HAL_IO)
rcomp.newpin('rdsel.set', hal.HAL_FLOAT, hal.HAL_IO, eps=1)
#rcomp.newpin('error', hal.HAL_BIT, hal.HAL_IN)
rcomp.ready()

# link remote component pins
rcomp.pin('drvctrl.reg').link(drvctrl)
rcomp.pin('chopconf.reg').link(chopconf)
rcomp.pin('smarten.reg').link(smarten)
rcomp.pin('sgcsconf.reg').link(sgcsconf)
rcomp.pin('drvconf.reg').link(drvconf)

rcomp.pin('full.0.val').link(fullval_0)
rcomp.pin('full.1.val').link(fullval_1)
rcomp.pin('full.2.val').link(fullval_2)
rcomp.pin('full.3.val').link(fullval_3)
rcomp.pin('full.4.val').link(fullval_4)
rcomp.pin('sg.readout').link(sgreadout)
rcomp.pin('stst.status').link(stststatus)
rcomp.pin('olb.status').link(olbstatus)
rcomp.pin('ola.status').link(olastatus)
rcomp.pin('s2gb.status').link(s2gbstatus)
rcomp.pin('s2ga.status').link(s2gastatus)
rcomp.pin('otpw.status').link(otpwstatus)
rcomp.pin('ot.status').link(otstatus)
rcomp.pin('sg.status').link(sgstatus)

rcomp.pin('intpol.set').link(intpol)
rcomp.pin('dedge.set').link(dedge)
rcomp.pin('mres.set').link(mres)

rcomp.pin('tbl.set').link(tbl)
rcomp.pin('chm.set').link(chm)
rcomp.pin('rndtf.set').link(rndtf)
rcomp.pin('hdec1.set').link(hdec1)
rcomp.pin('hdec0.set').link(hdec0)
rcomp.pin('hend.set').link(hend)
rcomp.pin('hstrt.set').link(hstrt)
rcomp.pin('toff.set').link(toff)

rcomp.pin('seimin.set').link(seimin)
rcomp.pin('sedn.set').link(sedn)
rcomp.pin('semax.set').link(semax)
rcomp.pin('seup.set').link(seup)
rcomp.pin('semin.set').link(semin)

rcomp.pin('sfilt.set').link(sfilt)
rcomp.pin('sgt.set').link(sgt)
rcomp.pin('cs.set').link(cs)

rcomp.pin('tst.set').link(tst)
rcomp.pin('slph.set').link(slph)
rcomp.pin('slpl.set').link(slpl)
rcomp.pin('diss2g.set').link(diss2g)
rcomp.pin('ts2g.set').link(ts2g)
rcomp.pin('sdoff.set').link(sdoff)
rcomp.pin('vsense.set').link(vsense)
rcomp.pin('rdsel.set').link(rdsel)

#rcomp.pin('error').link(error)

# ready to start the threads
hal.start_threads()

# start haltalk server after everything is initialized
# else binding the remote components on the UI might fail
hal.loadusr('haltalk')
