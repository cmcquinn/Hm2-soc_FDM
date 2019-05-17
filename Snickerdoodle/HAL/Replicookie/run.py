#!/usr/bin/python

import sys
import os
import subprocess
import importlib
import argparse
import time

from machinekit import launcher
from machinekit import config

launcher.set_debug_level(5)

def check_mklaucher():
    try:
        subprocess.check_output(['pgrep', 'mklauncher'])
        return True
    except subprocess.CalledProcessError:
        return False

os.chdir(os.path.dirname(os.path.realpath(__file__)))
c = config.Config()
os.environ["MACHINEKIT_INI"] = c.MACHINEKIT_INI

parser = argparse.ArgumentParser(description='This is the Replicookie-soc run script '
                                 'it demonstrates how a run script could look like '
                                 'and of course starts the Replicookie config')

parser.add_argument('-v', '--video', help='Starts the video server', action='store_true')

args = parser.parse_args()

try:
    launcher.check_installation()
    launcher.cleanup_session()
    launcher.register_exit_handler()  # needs to executed after HAL files
    launcher.install_comp('thermistor_check.comp')
    launcher.install_comp('reset.comp')
    launcher.install_comp('CoreXY.comp')
    nc_path = os.path.expanduser('~/nc_files')
    if not os.path.exists(nc_path):
        os.mkdir(nc_path)

    if not check_mklaucher():  # start mklauncher if not running to make things easier
        launcher.start_process('mklauncher .')
    launcher.start_process("configserver -n Replicookie ~/Machineface ")
    if args.video:
        launcher.start_process('videoserver --ini video.ini Webcam1')
    launcher.start_process('linuxcnc Replicookie.ini')
    while True:
        launcher.check_processes()
        time.sleep(1)
except subprocess.CalledProcessError:
    launcher.end_session()
    sys.exit(1)

sys.exit(0)
