from machinekit import hal
from machinekit import rtapi as rt
from machinekit import config as c

from fdm.config import base

import os
import sys


def hardware_read():
    hal.addf('hm2_5i25.0.read', 'servo-thread')
    hal.addf('hm2_5i25.0.read_gpio', 'servo-thread')


def hardware_write():
    hal.addf('hm2_5i25.0.write', 'servo-thread')
    hal.addf('hm2_5i25.0.write_gpio', 'servo-thread')


def init_hardware():
    watchList = []

    # Python user-mode HAL module to read ADC value and generate a thermostat output for PWM
    defaultThermistor = 'semitec_103GT_2'
    hal.loadusr('hal_temp_atlas',
                name='temp',

                filter_size=20,
                channels='00:%s,01:%s,02:%s,03:%s'
                % (c.find('HBP', 'THERMISTOR', defaultThermistor),
                   c.find('EXTRUDER_0', 'THERMISTOR', defaultThermistor),
                   c.find('EXTRUDER_1', 'THERMISTOR', defaultThermistor),
                   c.find('EXTRUDER_2', 'THERMISTOR', defaultThermistor)),
                wait_name='temp')
    watchList.append(['temp', 0.1])

    base.usrcomp_status('temp', 'temp-hw', thread='servo-thread')
    base.usrcomp_watchdog(watchList, 'estop-reset', thread='servo-thread',
                          errorSignal='watchdog-error')


def setup_hardware(thread):
    # PWM
    #hal.Pin('hm2_5i25.0.pwmgen.00.pwm_frequency').set(20000)  # 100Hz
#    os.system('halcmd setp hm2_5i25.0.pwmgen.00.pwm_frequency 20000')
    # HBP
#    hal.Pin('hm2_5i25.0.pwmgen.00.enable').set(True)
#    hal.Pin('hm2_5i25.0.pwmgen.00.value').link('hbp-temp-pwm')
    # Spindle
#    spindlespeed = hal.newsig('spindle-speed', hal.HAL_FLOAT)
#    spindleon = hal.newsig('spindle-on', hal.HAL_BIT)
#    spindlespeed20 = hal.newsig('spindle-speed-20', hal.HAL_FLOAT)
#    spindlepwmspeed = hal.newsig('spindle-pwm-speed', hal.HAL_FLOAT)
#    spindlepwmspeedlimited = hal.newsig('spindle-pwm-speed-limited', hal.HAL_FLOAT)

#    spindlespeed.link('motion.spindle-speed-out-rps')
#    spindleon.link('motion.spindle-on')
#    os.system('halcmd setp hm2_5i25.0.gpio.071.is_output true')
#    os.system('halcmd setp hm2_5i25.0.gpio.071.invert_output true')
#    hal.Pin('hm2_5i25.0.gpio.071.out').link(spindleon)

#    hal.Pin('hm2_5i25.0.pwmgen.00.enable').link(spindleon)
#    sum2 = rt.newinst('sum2', 'sum2.spindle-speed-add20')
#    hal.addf(sum2.name, 'servo-thread')
#    sum2.pin('in0').set(20)
#    sum2.pin('in1').link(spindlespeed)
#    sum2.pin('out').link(spindlespeed20)

#    div2 = rt.newinst('div2', 'div2.spindlespeed20-divfac')
#    hal.addf(div2.name, 'servo-thread')
#    div2.pin('in0').link(spindlespeed20)
#    div2.pin('in1').set(c.find('SPINDLE', 'FACTOR'))
#    div2.pin('out').link(spindlepwmspeed)

#    limit1 = rt.newinst('limit1', 'limit1.spindle-pwm-speed-limited')
#    hal.addf(limit1.name, thread)
#    limit1.pin('in').link(spindlepwmspeed)
#    limit1.pin('out').link(spindlepwmspeedlimited)
#    limit1.pin('min').set(0.05)  # prevent users from setting 0 as jog velocity
#    limit1.pin('max').set(c.find('SPINDLE', 'LIMIT'))

#    hal.Pin('hm2_5i25.0.pwmgen.00.value').link(spindlepwmspeedlimited)

    # configure extruders
#    for n in range(0, 1):
#        hal.Pin('hm2_5i25.0.pwmgen.%02i.enable' % (n + 1)).set(True)
#        hal.Pin('hm2_5i25.0.pwmgen.%02i.value' % (n + 1)).link('e%i-temp-pwm' % n)
    # configure fans
#    for n in range(0, 2):
#        hal.Pin('hm2_5i25.0.pwmgen.%02i.enable' % (n + 3)).link('f%i-pwm-enable' % n)
#        hal.Pin('hm2_5i25.0.pwmgen.%02i.value' % (n + 3)).link('f%i-pwm' % n)
#        hal.Signal('f%i-pwm-enable' % n).set(True)
    # configure exps
#    for n in range(0, 1):
#        hal.Pin('hm2_5i25.0.pwmgen.%02i.enable' % (n + 5)).link('exp%i-pwm-enable' % n)
#        hal.Pin('hm2_5i25.0.pwmgen.%02i.value' % (n + 5)).link('exp%i-pwm' % n)
#        hal.Signal('exp%i-pwm' % n).set(1.0)
    # configure leds
    # none

    # GPIO
    # Adjust as needed for your switch polarity
    hal.Pin('hm2_5i25.0.gpio.024.in_not').link('limit-0-home')   # X
#    hal.Pin('hm2_5i25.0.gpio.025.in').link('limit-1-0-home')    # YL
#    hal.Pin('hm2_5i25.0.gpio.026.in').link('limit-1-1-home')    # YR
#    hal.Pin('hm2_5i25.0.gpio.027.in_not').link('limit-2-home')    # Z

    # probe ... 74CBTD3861

#    hal.Pin('hm2_5i25.0.capsense.00.trigged').link('probe-signal')  #
#    os.system('halcmd setp hm2_5i25.0.capsense.00.hysteresis 0x44444444')
#    hm2_5i25.0.pin('capsense.00.hysteresis').set(c.find('PROBE', 'HYSTERESIS'))
#    hm2_5i25.0.pin('capsense.00.hysteresis').set(0x44444444))
#    hm2_5i25.0.pin('hysteresis').set(c.find('PROBE', 'HYSTERESIS'))
#    hm2_5i25.0.pin('hysteresis').set(17476)
#    hal.pin('hm2_5i25.0.capsense.00.hysteresis').set(1000))

    # ADC
#    hal.Pin('hm2_5i25.0.nano_soc_adc.ch.0.out').link('temp.ch-00.input')
#    hal.Pin('hm2_5i25.0.nano_soc_adc.ch.1.out').link('temp.ch-01.input')
#    hal.Pin('hm2_5i25.0.nano_soc_adc.ch.2.out').link('temp.ch-02.input')
#    hal.Pin('hm2_5i25.0.nano_soc_adc.ch.3.out').link('temp.ch-03.input')

#    hal.Pin('temp.ch-00.value').link('hbp-temp-meas')
#    hal.Pin('temp.ch-01.value').link('e0-temp-meas')
#    hal.Pin('temp.ch-02.value').link('e1-temp-meas')
#    hal.Pin('temp.ch-03.value').link('e2-temp-meas')

    # machine power
    os.system('halcmd setp hm2_5i25.0.gpio.033.is_output true')
    hal.Pin('hm2_5i25.0.gpio.033.out').link('emcmot-0-enable')

    # Monitor estop input from hardware
    hal.Pin('hm2_5i25.0.gpio.034.in_not').link('estop-in')
    # drive estop-sw
    os.system('halcmd setp hm2_5i25.0.gpio.035.is_output true')
    os.system('halcmd setp hm2_5i25.0.gpio.035.invert_output true')
    hal.Pin('hm2_5i25.0.gpio.035.out').link('estop-out')

    # Tie machine power signal to the Parport Cape LED
    # Feel free to tie any other signal you like to the LED
    os.system('halcmd setp hm2_5i25.0.gpio.031.is_output true')
    hal.Pin('hm2_5i25.0.gpio.031.out').link('emcmot-0-enable')

    # link emcmot.xx.enable to stepper driver enable signals
    os.system('halcmd setp hm2_5i25.0.gpio.032.is_output true')
    os.system('halcmd setp hm2_5i25.0.gpio.032.invert_output true')
    hal.Pin('hm2_5i25.0.gpio.032.out').link('emcmot-0-enable')

def setup_exp(name):
    hal.newsig('%s-pwm' % name, hal.HAL_FLOAT, init=0.0)
    hal.newsig('%s-enable' % name, hal.HAL_BIT, init=False)
