from machinekit import hal
from machinekit import rtapi as rt
from machinekit import config as c
from fdm.config import base

import os
import sys


def hardware_read():
    hal.addf('hm2_prot.0.read', 'servo-thread')
    hal.addf('hm2_prot.0.read_gpio', 'servo-thread')


def hardware_write():
    hal.addf('hm2_prot.0.write', 'servo-thread')
    hal.addf('hm2_prot.0.write_gpio', 'servo-thread')


def init_hardware():
    watchList = []

    # Python user-mode HAL module to read ADC value and generate a thermostat output for PWM
    defaultThermistor = 'semitec_103GT_2'
    hal.loadusr(
        'hal_temp_xadc',
        name='temp',
        filter_size=20,
        ref='y',
        #                channels='00:%s,01:%s,02:%s,03:%s'
        channels='vaux0:%s,vaux8:%s' %
        (c.find('HBP', 'THERMISTOR', defaultThermistor),
         c.find('EXTRUDER_0', 'THERMISTOR', defaultThermistor)),
        #                   c.find('EXTRUDER_1', 'THERMISTOR', defaultThermistor),
        #                   c.find('EXTRUDER_2', 'THERMISTOR', defaultThermistor)),
        wait_name='temp')
    watchList.append(['temp', 0.1])

    base.usrcomp_status('temp', 'temp-hw', thread='servo-thread')
    base.usrcomp_watchdog(watchList,
                          'estop-reset',
                          thread='servo-thread',
                          errorSignal='watchdog-error')


def setup_hardware(thread):
    # get number of pwmgens and stepgens from hm2 config string
    config = c.find('HOSTMOT2', 'CONFIG')
    config = config.split()
    params = dict(s.split('=') for s in config)

    # PWM
    for index in range(int(params['num_pwmgens'])):
        os.system('halcmd setp hm2_prot.0.pwmgen.{:02}.enable true'.format(index))
    
    # configure leds
    

    # GPIO
    # Adjust as needed for your switch polarity
    hal.Pin('hm2_prot.0.gpio.007.in_not').link('limit-0-max')  # X
    hal.Pin('hm2_prot.0.gpio.009.in_not').link('limit-1-max')  # Y

    hal.Pin('hm2_prot.0.gpio.007.in').link('limit-0-home')  # X
    hal.Pin('hm2_prot.0.gpio.009.in').link('limit-1-home')  # Y

    # probe ...

    #    hal.Pin('hm2_prot.0.capsense.00.trigged').link('probe-signal')  #

    # ADC
    hal.Pin('temp.vaux0.value').link('hbp-temp-meas')
    hal.Pin('temp.vaux8.value').link('e0-temp-meas')
    #    hal.Pin('temp.ch-02.value').link('e1-temp-meas')
    #    hal.Pin('temp.ch-03.value').link('e2-temp-meas')

    # machine power
    os.system('halcmd setp hm2_prot.0.gpio.000.is_output true')
    hal.Pin('hm2_prot.0.gpio.000.out').link('emcmot-0-enable')

    # Monitor estop input from hardware
    hal.Pin('hm2_prot.0.gpio.011.in_not').link('estop-in')
    # drive estop-sw
    os.system('halcmd setp hm2_prot.0.gpio.012.is_output true')
    os.system('halcmd setp hm2_prot.0.gpio.012.invert_output true')
    hal.Pin('hm2_prot.0.gpio.012.out').link('estop-out')

    # Tie machine power signal to the Parport Cape LED
    # Feel free to tie any other signal you like to the LED
    os.system('halcmd setp hm2_prot.0.gpio.013.is_output true')
    hal.Pin('hm2_prot.0.gpio.013.out').link('emcmot-0-enable')

    # link emcmot.xx.enable to stepper driver enable signals
    os.system('halcmd setp hm2_prot.0.gpio.008.is_output true')
    os.system('halcmd setp hm2_prot.0.gpio.008.invert_output true')
    hal.Pin('hm2_prot.0.gpio.008.out').link('emcmot-0-enable')

    os.system('halcmd setp hm2_prot.0.gpio.010.is_output true')
    os.system('halcmd setp hm2_prot.0.gpio.010.invert_output true')
    hal.Pin('hm2_prot.0.gpio.010.out').link('emcmot-1-enable')


def setup_exp(name):
    hal.newsig('%s-pwm' % name, hal.HAL_FLOAT, init=0.0)
    hal.newsig('%s-enable' % name, hal.HAL_BIT, init=False)
